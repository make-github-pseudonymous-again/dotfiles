import os
import sys
from datetime import datetime, timedelta, timezone
import traceback
import hashlib
from typing import Iterable
import human
import ics
import json

log = lambda *x, **y: print(*x, **y, file=sys.stderr)

CACHE = os.path.expanduser('~/.cache/calendar/{}')
FRESH = os.path.expanduser('~/.cache/calendar/fresh/{}')
CONFIG = os.path.expanduser('~/.config/calendar/config')

def _range ( now: datetime , begin: datetime , end: datetime ) :

    if end - begin < timedelta(days=1) :
        hour = True
    elif begin.replace(tzinfo=timezone.utc).time().minute != end.replace(tzinfo=timezone.utc).time().minute :
        hour = True
    elif begin.replace(tzinfo=timezone.utc).time().second != end.replace(tzinfo=timezone.utc).time().second :
        hour = True
    elif begin.replace(tzinfo=timezone.utc).time().hour in ( 22 , 23 , 0 ) and end.replace(tzinfo=timezone.utc).time().hour in ( 22 , 23 , 0 ) :
        hour = False
    else :
        hour = True

    if hour :

        bf = '%Y, %b %d, %H:%M'
        if begin.year == now.year:
            if begin.month == now.month:
                if begin.day == now.day:
                    bf = '%H:%M'
                else :
                    bf = '%a %d, %H:%M'
            else:
                bf = '%b %d, %H:%M'

        ef = '%Y, %b %d, %H:%M'
        if end.year == begin.year:
            if end.month == begin.month:
                if end.day == begin.day:
                    ef = '%H:%M'
                else:
                    ef = '%d, %H:%M'
            else:
                ef = '%b %d, %H:%M'

    else :

        bf = '%Y, %b %d'
        if begin.year == now.year:
            if begin.month == now.month:
                if begin.day == now.day:
                    bf = '%H:%M'
                else :
                    bf = '%a %d'
            else:
                bf = '%b %d'

        ef = '%Y, %b %d'
        if end - begin < timedelta(days=365) :
            if end.month == begin.month:
                ef = '%d'
            else:
                ef = '%b %d'

    return begin.strftime( bf ) + ' - ' + end.strftime( ef )

def calendars ( config: str = CONFIG ) :
    with open(config, 'r') as fd:
        return list(filter(lambda c: not c.get('hide'), json.load( fd )['calendars']))

def load ( calendars , cache: str = CACHE ) :
    calendar = ics.Calendar()
    calendar.events.update(_cache_load_calendars(calendars, cache = cache))
    return calendar

def _cache_load_calendars ( calendars , cache: str ) :
    for _calendar in calendars:
        yield from _cache_load_url(cache, _calendar['url'])

def url_hash ( url: str ) :
    return hashlib.sha1(url.encode()).hexdigest()

def _cache_load_url ( cache: str , url: str ) :

    h = url_hash(url)

    filename = cache.format(h)

    log('loading {} from {}'.format(url, filename))

    try:

        with open(filename, 'rb') as fd:
            data = fd.read()

        text = data.decode()
        calendar = ics.Calendar(text)
        return calendar.events

    except ics.grammar.parse.ParseError as err:

        log('Error parsing file: {}'.format(url))
        log(err)
        traceback.print_tb(err.__traceback__, file=sys.stderr)
        return set()

    except FileNotFoundError as err:

        log('Error reading cache for: {}'.format(url))
        log(err)
        traceback.print_tb(err.__traceback__, file=sys.stderr)
        return set()


def _match(it: Iterable[str], text: str):
    for line in it:
        if line == text : break

def _dropalarms(string: str):
    it = iter(string.splitlines())
    for line in it:
        if line == 'BEGIN:VALARM' : _match(it, 'END:VALARM')
        else: yield line

def dropalarms(string: str):
    return '\n'.join(_dropalarms(string))


def main ( now: datetime , events: Iterable[ics.Event] ) :

    _fresh = list(filter(lambda x: x.end >= now, events))
    _future = filter(lambda x: x.begin >= now, _fresh)
    _happening = filter(lambda x: x.begin < now, _fresh)
    _current = min(_happening, key=lambda x: x.end, default=None)
    _next = min(_future, key=lambda x: x.begin, default=None)

    if _current is None:

        if _next is None:

            raise ValueError('no main event')

        else:

            return _next

    else:

        return _current if _next is None or _next.begin >= _current.end else _next


def event_to_i3_status_object ( now: datetime , event: ics.Event ) :

    name = event.name
    location = event.location
    short_location = location.split(',')[0] if location else None
    begin = event.begin.datetime.astimezone()
    end = event.end.datetime.astimezone()

    # event format
    ef = '{name}'
    if location and location not in name:
        ef += ' ( {location})'

    if begin < now:
        ef += ' - (started {hbegin}, ends {hend})'
    else:
        ef += ' - {range} ({hbegin})'

    full_text = ef.format(
        range = _range( now , begin , end ) ,
        hbegin = human.datetime(begin),
        hend = human.datetime(end) ,
        name = name,
        location = location
    )

    full_text = full_text.replace('\r', '')
    full_text = full_text.replace('\n', ' ')

    short_text = ef.format(
        range = _range( now , begin , end ) ,
        hbegin = human.datetime(begin),
        hend = human.datetime(end) ,
        name = (name[:47] + '..') if len(name) > 49 else name,
        location = short_location
    )

    short_text = short_text.replace('\r', '')
    short_text = short_text.replace('\n', ' ')

    return {
        "name":"calendar",
        "color":"#A7C5BD",
        "full_text":" {}".format(full_text),
        "short_text":" {}".format(short_text)
    }


# FORMAT TIME

def _humanize(time, ref):

    x = time.humanize(ref)

    if x == "in seconds":

        return "in {} seconds".format((time - ref).seconds)

    if x == "just now":

        return "now"

    return x


def _duration(A, B):

    x = _humanize(B, A)

    if x == 'now':

        return '{} seconds'.format((B - A).seconds)

    if x == 'in a minute':

        return '1 minute'

    return x[3:]


def _shortduration(A, B):

    return _shorten(_duration(A, B))


def _shorthumanize(time, ref):

    return _shorten(_humanize(time, ref))

def _tinyduration(A, B):

    return _tinier(_duration(A, B))


def _tinyhumanize(time, ref):

    return _tinier(_humanize(time, ref))


def _shorten(x):

    if 'minutes' in x or 'seconds' in x:

        return x[:-4]

    if 'minute' in x:

        return x[:-3]

    return x

def _tinier(x):

    if 'minutes' in x or 'seconds' in x:

        return x[:-6]

    if 'minute' in x:

        return x[:-5]

    return x
