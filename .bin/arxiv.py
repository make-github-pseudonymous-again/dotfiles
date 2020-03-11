#!/usr/bin/env python3

import os
import re

from itertools import chain

from offline import escape_filename
from offline import sanitize

DEFAULT_CACHE = os.path.expanduser("~/.cache/arxiv-downloader")
DEFAULT_CONFIG = os.path.expanduser("~/.config/arxiv-downloader/config.json")

DEFAULT_ENDPOINT = 'https://export.arxiv.org/api/query?sortBy=submittedDate&sortOrder=ascending&search_query={search_query}&max_results={max_results}&start={start}'
DEFAULT_FORMAT_LINKNAME = "{year:04}{month:02}{day:02} [{initials}{year:02}] {title} (arxiv:{uid})"

DEFAULT_STORAGE = '/tmp/arxiv-downloader/{type}/{uid}{ext}'
DEFAULT_INDEX = '/tmp/arxiv-downloader/index/{tag}/{slug}{ext}'

DEFAULTS = {
    "format": DEFAULT_FORMAT_LINKNAME,
    "storage": DEFAULT_STORAGE,
    "index": DEFAULT_INDEX,

    "endpoint": DEFAULT_ENDPOINT,
    "cache": DEFAULT_CACHE,
    "config": DEFAULT_CONFIG,
}


def get_lastname_first_letter(name):
    if ',' in name:
        lastname = name.split(', ')[0]
    else:
        lastname = name.split(' ')[-1]

    return lastname[0]


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
    return string not in NOT_A_TAG


get_uid = lambda m: m['id'].split('/abs/')[-1]

def get_resources ( m ) :

    for link in filter(lambda x: x.get('type', None) == 'application/pdf', m.get('links', [])):

        yield {
            "type": "storage",
            "ext" : ".pdf",
            "url" : link['href'] ,
            "content_type": "application/pdf",
        }

        break

def compile_metadata ( title=None, authors=None, **entry ) :

    title = sanitize(title)
    authors = list(map(lambda x: sanitize(x['name']), authors))
    published = entry['published']

    year, month, day, *_ = entry['published_parsed']

    initials = ''.join(
        sorted(map(get_lastname_first_letter, authors)))

    # max_initials_length = 3
    # initials_truncated = (initials[:max_initials_length] + '+') if len(initials) > max_initials_length else initials

    return dict(
        **entry,
        title=title,
        authors=authors,
        year=year,
        month=month,
        day=day,
        initials=initials,
    )


def generate_tags ( entry ) :

    authors = list(map(lambda x: sanitize(x['name']), entry['authors']))
    tags = list(chain(*map(lambda x: extract_tags(x['term']), entry['tags'])))

    for resource in get_resources( entry ) :

        yield resource, "all"

        for author in authors:
            yield resource, "author/{}".format(escape_filename(author))

        for tag in tags:
            yield resource, "tag/{}".format(escape_filename(tag))


