#!/usr/bin/env python3

import os
import sys
import time
import json
import re
import urllib.request
import feedparser
import shutil

from itertools import islice
from itertools import chain

from collections import ChainMap
from collections import Counter
from collections import defaultdict

from copy import copy
import inotify.adapters

log = lambda *x, **y: print(*x, **y, file=sys.stderr)

delimit = lambda c: log(c*79)

def logjson ( x , fp = sys.stderr , indent=2 ) :
    json.dump(x, fp, indent=indent)
    log()

def dumpjson ( x , fp = sys.stdout, separators=(',', ':') ) :
    # https://docs.python.org/3/library/json.html?highlight=json#json.dump
    json.dump(x, fp, separators=separators)


_sorted_return_codes = (
    'done',
    'missing config',
    'mangled config',
    'mangled state',
    'mangled index_state',
    'continue',
    'failed search query',
    'failed download',
)

DEFAULT_HEADERS = {'User-Agent': 'Mozilla'}

RC = { key: 0 if i==0 else 2**(i-1) for i, key in enumerate(_sorted_return_codes) }

RC_MIRROR = { value: key for key, value in RC.items()}

def _rc_decode ( code ) :
    for key in reversed(_sorted_return_codes):
        value = RC[key]
        if value & code or value == code:
            yield key

def rc_decode ( code ) :
    return list(_rc_decode(code))

# TECHNICAL
DEFAULT_THROTTLE = 3
DEFAULT_BATCH = 1
DEFAULT_TIMEOUT = 60
DEFAULT_INDEX_POLLING_INTERVAL = 60
DEFAULT_FORMAT_SUMMARY = 'query:"{query}" total({total}) dl({counts}) state({old_state} (+{progress}) -> {new_state}) rc({rc}: {message})'
DEFAULT_INDEX_FORMAT_SUMMARY = 'files(+{count[files]}) tags(+{count[tags]}) state({old_state[mtime]} -> {new_state[mtime]})'

# SAFE DEFAULTS FOR TESTING
DEFAULT_CHECK = False
DEFAULT_STORAGE = '/tmp/offline/{type}/{uid}{ext}'
DEFAULT_INDEX = '/tmp/offline/index/{tag}/{slug}{ext}'
DEFAULT_FORMAT_LINKNAME = "{uid}"
DEFAULT_QUERIES = ()

# SANE DEFAULTS FOR REGULAR USAGE
DEFAULT_CHECK_MTIME = True
DEFAULT_CHECK_CONTENT_TYPE = True
DEFAULT_METADATA_TYPE = 'metadata'
DEFAULT_METADATA_EXTENSION = '.json'
DEFAULT_STATE = '{}/state.json'
DEFAULT_INDEX_STATE = '{}/index.json'


DEFAULTS = {

    "throttle": DEFAULT_THROTTLE,
    "batch": DEFAULT_BATCH,
    "timeout": DEFAULT_TIMEOUT,
    "summary": DEFAULT_FORMAT_SUMMARY,
    "index_summary": DEFAULT_INDEX_FORMAT_SUMMARY,
    "index_polling_interval": DEFAULT_INDEX_POLLING_INTERVAL,

    "check": DEFAULT_CHECK,
    "check_mtime": DEFAULT_CHECK_MTIME,
    "check_content_type": DEFAULT_CHECK_CONTENT_TYPE,
    "storage": DEFAULT_STORAGE,
    "index": DEFAULT_INDEX,
    "format": DEFAULT_FORMAT_LINKNAME,
    "queries": DEFAULT_QUERIES,

    "metadata_type": DEFAULT_METADATA_TYPE,
    "metadata_ext": DEFAULT_METADATA_EXTENSION,
    "state": DEFAULT_STATE,
    "index_state": DEFAULT_INDEX_STATE,
}


def escape_filename(string):
    return string.replace('\\', '\\\\').replace('|', '\\|').replace('/', '|')


def unescape_filename(filename):
    return filename.replace('|', '/').replace('\\|', '|').replace('\\\\', '\\')

def wait ( seconds ):
    log('Sleeping for {} seconds'.format(seconds))
    time.sleep(seconds)

def sanitize ( string ):
    return re.sub(r'\s+', ' ', string).strip()

def get_arg_parser(default_config=None, description = 'Feed downloader.'):

    import argparse

    parser = argparse.ArgumentParser(description=description)

    # These are purely technical and have sensible defaults.
    parser.add_argument('--throttle', '-t', type=int, help='query delay')
    parser.add_argument('--timeout', '-T', help='timeout for requests')
    parser.add_argument('--batch', '-b', type=int, help='batch size')
    parser.add_argument('--summary', help='format string for summary')
    parser.add_argument('--index-summary', help='format string for summary')
    parser.add_argument('--index-polling-interval', help='polling interval for inotify')
    parser.add_argument('--check-mtime', help='check file modification time in indexer')
    parser.add_argument('--check-content-type', help='check http content type in downloader')

    # Those do not have sensible defaults but one can run the program without.
    parser.add_argument('--config', '-c', default=default_config, help='config file')
    parser.add_argument('--state', '-S', help='state file')
    parser.add_argument('--index-state', help='index state file')

    # These can have default for testing purposes.
    parser.add_argument('--check', '-C', help='check that downloaded files have correct size')
    parser.add_argument('--storage', '-s', help='storage path format')
    parser.add_argument('--index', '-i', help='index path')
    parser.add_argument('--format', '-f', help='format string for filename')
    parser.add_argument('--queries', '-q', nargs='*', help='queries')
    parser.add_argument('--metadata-type', help='resource type for metadata')
    parser.add_argument('--metadata-ext', help='file extension for metadata')

    # These do not have defaults and it does not make sense for the library to
    # set a default.
    parser.add_argument('--endpoint', '-r', help='endpoint')

    return parser

def get_slug ( format , title=None, **kwargs ) :

    # does not work if title appears twice in format

    max_filename_length = 255 - 5 # Take into account .json suffix

    slug = format.format(title=title, **kwargs)

    slug_escaped = escape_filename(slug)

    extra = len(slug_escaped) - max_filename_length

    if extra > 0:

        title_truncated = title[:-(2*extra+2)] + '..' # * 2 in case of escaped characters

        slug = format.format(title=title_truncated, **kwargs)

        slug_escaped = escape_filename(slug)

    return slug_escaped


def get_params ( kwargs, *defaults ) :

    kwargs = { key: value for key, value in kwargs.items() if value is not None }

    kwargs2 = ChainMap(kwargs, *defaults)

    if kwargs2['config'] is None:
        log("! Warning: working without a config file!")
        _config = {}
    else:
        config = os.path.expanduser(kwargs2['config'])
        log('> config file: {}'.format(config))

        try:
            with open(config) as fp:
                _config = json.load(fp)
        except json.decoder.JSONDecodeError as e:
            log("! Error: Could not load config file ({})".format(config))
            log(e)
            sys.exit(RC['mangled config'])
        except:
            if config == ChainMap(*defaults, DEFAULTS).get('config', None):
                log("! Warning: could not open default config file!")
                _config = {}
            else:
                log("! Error: Could not open config file ({})".format(config))
                sys.exit(RC['missing config'])

    params = ChainMap(kwargs, _config, *defaults, DEFAULTS)

    log('> params details', end = ' ')
    logjson(vars(params))
    log('> params', end = ' ')
    logjson(dict(**params))

    return params

def get_state_path ( key, params ) :
    return get_path_from_format_or_execute(params[key], params['cache'])

def get_state ( key, params ) :

    _state = {}

    if key in params:
        state = get_state_path(key, params)
        log('> {} file: {}'.format(key, state))

        try:
            with open(state) as fp:
                _state = json.load(fp)
        except json.decoder.JSONDecodeError as e:
            log("! Error: Could not load {} file ({})".format(key, state))
            log(e)
            sys.exit(RC['mangled {}'.format(key)])
        except:
            log('! Warning: {} file is configured but could not load its contents!'.format(key))

    else:
        log('! Warning: No {} path provided. Will proceed without it.'.format(key))


    log('> {}'.format(key), end = ' ')
    logjson(_state)

    return Counter(_state)

def dump_state ( key, params , _state):
    if key in params:
        state = get_state_path(key, params)
        os.makedirs(os.path.dirname(state), exist_ok=True)
        with open(state, 'w') as fp:
            dumpjson(_state, fp)
    else:
        log('Not saving {key} because no {key} path given. Here it is anyway!'.format(key=key))
        dumpjson(_state)

def urlopen ( url , **kwargs) :
    request = urllib.request.Request(url, headers=DEFAULT_HEADERS)
    return urllib.request.urlopen(request, **kwargs)

class ContentTypeMismatchException(Exception):
    def __init__ ( self , *args, **kwargs):
        super().__init__(*args, **kwargs)

def validate_content_length ( url , path , **kwargs ) :

    try:
        size = os.path.getsize(path)
        log("Validating content-length for {}".format(url))
        with urlopen(url, **kwargs) as response:
            content_length = int(response.info().get('Content-Length'))

        if size == content_length: return True

        log("Content length mismatch: expected {} got {}".format(content_length, size))

    except Exception as e:
        log("Could not validate content-length.")
        log(e)

    return False


def download ( url , path , expected_content_type = None , **kwargs ) :

    log("Checking headers of {}".format(url))
    with urlopen(url, **kwargs) as response:

        if expected_content_type is not None:
            content_type = response.info().get_content_type()
            if content_type != expected_content_type:
                msg = '{}: Received {} while expecting {}'.format(url, content_type, expected_content_type)
                raise ContentTypeMismatchException(msg)

        log("Downloading {} to {}.".format(url, path))
        with open(path, 'wb') as fp:
            # https://github.com/python/cpython/blob/7b3ab5921fa25ed8b97b6296f97c5c78aacf5447/Lib/shutil.py#L194-L205
            # implement progress bar?
            shutil.copyfileobj(response, fp)

def format_or_execute ( string_or_function, *args, **kwargs ) :

    if isinstance(string_or_function, str):
        fn = string_or_function.format
    else:
        fn = string_or_function

    return fn(*args, **kwargs)

def get_path_from_format_or_execute ( *args, **kwargs ) :
    path = format_or_execute(*args, **kwargs)
    return os.path.expanduser(path)

def download_once (
        _state = None , throttle = None , batch = None ,
        storage = None , metadata_type = None, metadata_ext = None, queries = None ,
        endpoint = None , timeout = None, summary = None,
        get_uid = None, get_resources = None , check = None ,
        check_content_type = None, reverse_entries = False, **kwargs ) :

    delimit('=')

    _old_state = copy(_state)
    rc = defaultdict(lambda: RC['done'])
    count = defaultdict(Counter)
    total = Counter()

    for search_query in queries:
        log("search_query", search_query)
        start = _state.setdefault(search_query, 0)

        query_url = endpoint.format(search_query=search_query, start=start, max_results=batch)
        log(query_url)

        wait(throttle)
        try:
            response = urlopen(query_url, timeout=timeout)
        except Exception as e:
            log('Failed to query', query_url)
            log(e)
            rc[search_query] = RC['failed search query']
            break

        document = feedparser.parse(response)
        feed = document.feed

        opensearch_startindex = int(feed.get('opensearch_startindex', 0))
        total[search_query] = int(feed.get('opensearch_totalresults', -1))

        increment_state = 1

        _start = start-opensearch_startindex
        _stop = _start + batch

        entries = document.entries
        if reverse_entries: entries = reversed(entries)
        entries = islice(entries, _start, _stop)

        for entry in entries:

            delimit('+')

            uid = get_uid(entry)
            uid_escaped = escape_filename(uid)

            logmetadata(uid, entry)

            metadata_path = get_path_from_format_or_execute(storage, type=metadata_type, uid=uid_escaped, ext=metadata_ext)
            metadata_dir = os.path.dirname(metadata_path)

            for i, resource in enumerate(get_resources(entry), 1):

                resource_type = resource['type']
                resource_url = resource['url']
                resource_ext = resource['ext']
                resource_content_type = resource.get('content_type', None)
                resource_path = get_path_from_format_or_execute(storage, type=resource_type, uid=uid_escaped, ext=resource_ext)
                resource_dir = os.path.dirname(resource_path)

                log('Resource #{}: {}'.format(i, resource_url))

                try:
                    exists = os.path.getsize(resource_path) > 0
                except:
                    exists = False

                if exists and (not check or validate_content_length(resource_url, resource_path, timeout=timeout)):
                    log("{} already exists, skipping".format(resource_path))
                else:
                    os.makedirs(resource_dir, exist_ok=True)

                    wait(throttle)

                    try:
                        download(resource_url, resource_path, expected_content_type=resource_content_type, timeout=timeout)
                        count[search_query][resource_type] += 1
                    except Exception as e:
                        log("Failed to download", resource_url)
                        log(e)
                        rc[search_query] = RC['failed download']
                        try:
                            log("Cleaning up...")
                            if os.path.exists(resource_path):
                                log("Removing", resource_path)
                                os.remove(resource_path)
                                log("Success :)")
                            else:
                                log("Nothing to do!")
                        except Exception as e:
                            log("Clean up failed :(")
                            log(e)

                        if not isinstance(e, ContentTypeMismatchException):
                            increment_state = 0
                            break
                        elif check_content_type:
                            increment_state = 0

                os.makedirs(metadata_dir, exist_ok=True)
                with open(metadata_path, 'w') as fp:
                    dumpjson(entry, fp)
                    count[search_query]['metadata'] += 1

                _state[search_query] += increment_state

        delimit('+')


    dump_state('state', kwargs, _state)

    for search_query in queries:
        incomplete_single_query = opensearch_startindex == 0 and _state[search_query] < len(document.entries)
        if (total[search_query] < 0 and incomplete_single_query) or _state[search_query] < total[search_query]:
            rc[search_query] = max(rc[search_query], RC['continue'])

    delimit('=')

    print_summary( summary , queries , _old_state , _state , count , rc , total )

    delimit('=')

    return max(rc.values())


def print_summary ( summary , queries, old_state, new_state, count, rc , total) :

    for search_query in queries:

        _old_state = old_state[search_query]
        _new_state = new_state[search_query]
        _progress = _new_state - _old_state

        counts = ', '.join(map(lambda x: '{}: {}'.format(*x), sorted(count[search_query].items()))) or '-'
        message = ', '.join(rc_decode(rc[search_query]))

        summary_options = dict(
            query = search_query,
            counts = counts,
            old_state = _old_state,
            new_state = _new_state,
            progress = _progress,
            message = message,
            rc = rc[search_query],
            total = total[search_query],
        )

        summary_string = format_or_execute(summary, **summary_options)

        log(summary_string)

def logmetadata ( uid , entry ) :

    title = sanitize(entry['title'])
    authors_names = list(map(lambda x: sanitize(x['name']), entry['authors']))

    log(' + uid: {}'.format(uid))
    log(' + permalink: {}'.format(entry['id']))
    log(' + Published: {}'.format(entry['published']))
    log(' + Title:  {}'.format(title))
    log(' + Authors:  {}'.format(', '.join(authors_names)))
    # log('Summary:  {}'.format(entry['summary']))


get_uid_from_filename = lambda x: unescape_filename(os.path.splitext(x)[0])


def index_once ( uids , _state = None , state = None ,
        storage = None , metadata_type = None , metadata_ext = None , index = None ,
        format = None, compile_metadata = None, generate_tags = None,
        index_summary = None , **kwargs ) :

    old_state = _state
    new_state = copy(old_state)
    count = Counter()

    for uid in uids:

        delimit('=')

        log('indexing', uid)

        uid_escaped = escape_filename(uid)
        metadata_path = get_path_from_format_or_execute(storage, type=metadata_type, uid=uid_escaped, ext=metadata_ext)

        statinfo = os.stat(metadata_path)
        metadata_mtime = statinfo.st_mtime

        new_state['mtime'] = max(new_state['mtime'], metadata_mtime)

        with open(metadata_path) as fd:
            _metadata = json.load(fd)

        logmetadata(uid, _metadata)

        info = compile_metadata(**_metadata)

        slug = get_slug(format, uid=uid, **info)

        for resource, tag in generate_tags(_metadata):

            resource_type = resource['type']
            resource_ext = resource['ext']
            resource_path = get_path_from_format_or_execute(storage, type=resource_type, uid=uid_escaped, ext=resource_ext)

            link_path = get_path_from_format_or_execute(index, tag=tag, slug=slug, ext=resource_ext)
            link_dir = os.path.dirname(link_path)
            os.makedirs(link_dir, exist_ok=True)
            try:
                os.symlink(resource_path, link_path)
                count['tags'] += 1
            except FileExistsError as e:
                pass

        count['files'] += 1


    if new_state != old_state:
        dump_state('index_state', kwargs, new_state)

    if count['files'] > 0:
        delimit('=')
        summary_string = format_or_execute(index_summary, count=count, old_state=old_state, new_state=new_state)
        log(summary_string)

    return new_state

def get_metadata_dir ( storage , metadata_type ):
    return get_path_from_format_or_execute(storage, type=metadata_type, uid='', ext='')

not_a_syncthing_file = lambda x: 'sync-conflict' not in x and 'syncthing' not in x

def non_syncthing_files ( filenames ) :
    return filter(not_a_syncthing_file, filenames)

def get_files ( directory ):
    return non_syncthing_files(os.listdir(directory))

def index_init ( storage = None , metadata_type = None , **kwargs ) :

    metadata_dir = get_metadata_dir(storage , metadata_type)

    uids = map(get_uid_from_filename, get_files(metadata_dir))

    return index_once( uids , storage = storage , metadata_type = metadata_type, **kwargs )

def index_daemon ( _state = None, check_mtime = None , storage = None ,
        metadata_type = None , index_polling_interval = None , **kwargs ) :

    metadata_dir = get_metadata_dir( storage , metadata_type)

    i = inotify.adapters.Inotify(block_duration_s=index_polling_interval)
    i.add_watch(metadata_dir)

    log('+ Info: READY!')

    out_of_sync = []

    if check_mtime and os.stat(metadata_dir).st_mtime >= _state['mtime']:
        for filename in get_files(metadata_dir):
            path = metadata_dir + '/' + filename
            if os.stat(path).st_mtime >= _state['mtime']:
                uid = get_uid_from_filename(filename)
                out_of_sync.append(uid)

    if out_of_sync:
        log('+ Info: {} files are out of sync.'.format(len(out_of_sync)))

    sentinel_and_close_write_events = lambda e: e is None or ('IN_CLOSE_WRITE' in e[1] and not_a_syncthing_file(e[3]))
    to_uid_or_none = lambda e: None if e is None else get_uid_from_filename(e[3])
    inotify_events = map(to_uid_or_none, filter(sentinel_and_close_write_events, i.event_gen()))
    events = chain(out_of_sync, inotify_events)
    index_events(events, _state = _state , storage = storage, metadata_type=metadata_type, **kwargs)

def index_events ( events , _state = None, **kwargs ) :

    queue = []

    for uid in events:

        if uid is None:
            _state = index_once( queue , _state = _state , **kwargs )
            queue = []

        else:
            queue.append(uid)
