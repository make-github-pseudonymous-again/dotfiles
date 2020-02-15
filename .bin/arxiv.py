#!/usr/bin/env python3

import os
import sys
import time
import json
import re
import urllib.request
import feedparser
import shutil
from collections import ChainMap

log = lambda *x, **y: print(*x, **y, file=sys.stderr)

_sorted_return_codes = (
    'done',
    'missing config',
    'continue',
    'failed search query',
    'failed download',
)


RC = { key: 0 if i==0 else 2**(i-1) for i, key in enumerate(_sorted_return_codes) }

RC_MIRROR = { value: key for key, value in RC.items()}

def _rc_decode ( code ) :
    for key in reversed(_sorted_return_codes):
        value = RC[key]
        if value & code:
            yield key

def rc_decode ( code ) :
    return list(_rc_decode(code))

DEFAULT_CACHE = os.path.expanduser("~/.cache/arxiv-downloader")
DEFAULT_STATE = '{}/state.json'.format(DEFAULT_CACHE)
DEFAULT_CONFIG = os.path.expanduser("~/.config/arxiv-downloader/config.json")

DEFAULT_REQUEST = 'https://export.arxiv.org/api/query?sortBy=submittedDate&sortOrder=ascending&search_query={search_query}&max_results={max_results}&start={start}'

DEFAULT_FORMAT = "{year}{month}{day} [{abbr}] {title} (arxiv:{uid})"

DEFAULT_THROTTLE = 3
DEFAULT_BATCH = 1
DEFAULT_STORAGE = '/tmp/arxiv-downloader/storage'
DEFAULT_METADATA = '/tmp/arxiv-downloader/metadata'
DEFAULT_INDEX = '/tmp/arxiv-downloader/index'
DEFAULT_QUERIES = ()

DEFAULT_TIMEOUT = 60

DEFAULTS = {
    "cache": DEFAULT_CACHE,
    "state": DEFAULT_STATE,
    "config": DEFAULT_CONFIG,
    "request": DEFAULT_REQUEST,
    "format": DEFAULT_FORMAT,
    "throttle": DEFAULT_THROTTLE,
    "batch": DEFAULT_BATCH,
    "storage": DEFAULT_STORAGE,
    "metadata": DEFAULT_METADATA,
    "index": DEFAULT_INDEX,
    "queries": DEFAULT_QUERIES,
    "timeout": DEFAULT_TIMEOUT,
}


def escape_filename(string):
    return string.replace('\\', '\\\\').replace('|', '\\|').replace('/', '|')


def unescape_filename(filename):
    return filename.replace('|', '/').replace('\\|', '|').replace('\\\\', '\\')


def get_lastname_first_letter(name):
    if ',' in name:
        lastname = name.split(', ')[0]
    else:
        lastname = name.split(' ')[-1]

    return lastname[0]


def wait ( seconds ):
    log('Sleeping for {} seconds'.format(seconds))
    time.sleep(seconds)

def sanitize ( string ):
    return re.sub(r'\s+', ' ', string).strip()

def get_arg_parser():

    import argparse

    parser = argparse.ArgumentParser(description='Generate a secure random PIN.')
    parser.add_argument('--config', '-c', default=DEFAULT_CONFIG, help='config file')
    parser.add_argument('--state', '-S', help='state file')
    parser.add_argument('--throttle', '-t', type=int, help='query delay')
    parser.add_argument('--batch', '-b', type=int, help='batch size')
    parser.add_argument('--storage', '-s', help='storage path')
    parser.add_argument('--metadata', '-m', help='metadata path')
    parser.add_argument('--index', '-i', help='index path')
    parser.add_argument('--queries', '-q', nargs='*', help='queries')
    parser.add_argument('--request', '-r', help='arXiv API request')
    parser.add_argument('--format', '-f', help='format string for filename')
    parser.add_argument('--timeout', '-T', help='timeout for requests')

    return parser

def get_slug ( format , title=None, abbr=None, **kwargs ) :

    # does not work if title appears twice in format

    max_filename_length = 255 - 5 # Take into account .json suffix
    # max_abbr_length = 3

    # abbr_truncated = (abbr[:max_abbr_length] + '+') if len(abbr) > max_abbr_length else abbr

    abbr_truncated = abbr

    slug = format.format(title=title, abbr=abbr_truncated, **kwargs)

    slug_escaped = escape_filename(slug)

    extra = len(slug_escaped) - max_filename_length

    if extra > 0:

        title_truncated = title[:-(2*extra+2)] + '..' # * 2 in case of escaped characters

        slug = format.format(title=title_truncated, abbr=abbr_truncated, **kwargs)

        slug_escaped = escape_filename(slug)

    return slug_escaped


def get_params ( kwargs ) :

    kwargs = { key: value for key, value in kwargs.items() if value is not None }

    config = os.path.expanduser(kwargs['config'])
    log('config file: {}'.format(config))

    try:
        with open(config) as fp:
            _config = json.load(fp)
    except:
        if config == DEFAULT_CONFIG:
            pass
        else:
            log("Could not open config file ({})".format(config))
            sys.exit(RC['missing config'])

    params = ChainMap(kwargs, _config, DEFAULTS)

    log('params')
    json.dump(vars(params), sys.stderr, indent=2)
    log()

    return params

def get_state ( params ) :

    state = os.path.expanduser(params['state'])
    log('state file: {}'.format(state))

    try:
        with open(state) as fp:
            _state = json.load(fp)
    except:
        _state = {}


    log('state')
    json.dump(_state, sys.stderr, indent=2)
    log()

    return _state

def extract_tags ( term ) :
    matches = re.findall(r"[\w.]+", term)
    return filter(is_tag, map(sanitize_tag, matches))

def sanitize_tag ( string ) :

    string = string.lower()

    string = string.strip(' .')

    return string

NOT_A_TAG = {
    'primary',
    'secondary',
}

def is_tag ( string ) :

    if string in NOT_A_TAG: return False

    return True


def download ( url , filename , **kwargs ) :
    with urllib.request.urlopen(url, **kwargs) as response:
        with open(filename, 'wb') as fp:
            shutil.copyfileobj(response, fp)
