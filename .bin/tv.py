#!/usr/bin/env python3

import os
import re

from itertools import chain

from offline import escape_filename
from offline import sanitize

DOMAIN_NAME = 'thi' + 'nkerv' + 'iew' + '.com'

DEFAULT_CACHE = os.path.expanduser("~/.cache/tv-downloader")
DEFAULT_STATE = '{}/state.json'
DEFAULT_CONFIG = os.path.expanduser("~/.config/tv-downloader/config.json")

DEFAULT_ENDPOINT = 'https://' + DOMAIN_NAME + '/feed/'
DEFAULT_QUERIES = ('*', )
DEFAULT_FORMAT_LINKNAME = "{year:04}{month:02}{day:02} {title} (tv:{uid})"

DEFAULT_STORAGE = '/tmp/tv-downloader/{type}/{uid}{ext}'
DEFAULT_INDEX = '/tmp/tv-downloader/index/{tag}/{slug}{ext}'

DEFAULTS = {
    "format": DEFAULT_FORMAT_LINKNAME,
    "storage": DEFAULT_STORAGE,
    "index": DEFAULT_INDEX,
    "queries": DEFAULT_QUERIES,

    "endpoint": DEFAULT_ENDPOINT,
    "cache": DEFAULT_CACHE,
    "state": DEFAULT_STATE,
    "config": DEFAULT_CONFIG,
}

def get_uid (entry) :
    return entry['id'].split('=')[-1]

def get_slug (entry) :
    return entry['link'].split('/')[-2]

def get_resources ( entry ):

    audio_url = 'https://www.' + DOMAIN_NAME + '/podcast-player/{uid}/{slug}.mp3?_=1'

    uid = get_uid(entry)
    slug = get_slug(entry)

    yield {
        "type": "mp3",
        "ext": ".mp3",
        "url": audio_url.format(uid=uid, slug=slug),
        "content_type": "audio/mpeg",
    }

def compile_metadata ( title=None, authors=None, **entry ) :

    title = sanitize(title)
    authors = list(map(lambda x: sanitize(x['name']), authors))
    published = entry['published']

    year, month, day, *_ = entry['published_parsed']

    return dict(
        **entry,
        title=title,
        authors=authors,
        year=year,
        month=month,
        day=day,
    )

def sanitize_tag ( string ) :
    string = string.lower()
    return string

def is_tag ( string ) :
    return True

def extract_tags ( term ) :
    matches = re.findall(r"[\w]+", term)
    return filter(is_tag, map(sanitize_tag, matches))

def extract_authors ( name ) :
    if name != ('Thi' + 'nkerv' + 'iew'): yield name

def generate_tags ( entry ) :

    authors = list(chain(*map(lambda x: extract_authors(x['name']), entry['authors'])))
    tags = list(chain(*map(lambda x: extract_tags(x['term']), entry['tags'])))

    for resource in get_resources( entry ) :

        yield resource, "all"

        for author in authors:
            yield resource, "author/{}".format(escape_filename(author))

        for tag in tags:
            yield resource, "tag/{}".format(escape_filename(tag))
