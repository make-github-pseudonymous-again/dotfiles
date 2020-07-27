import os
import sys
import datetime
import traceback
import hashlib
import ics
import json

log = lambda *x, **y: print(*x, **y, file=sys.stderr)

CACHE = os.path.expanduser('~/.cache/calendar/{}')
FRESH = os.path.expanduser('~/.cache/calendar/fresh/{}')
CONFIG = os.path.expanduser('~/.config/calendar/config')

def _range ( now , begin , end ) :

    if end - begin < datetime.timedelta(1) :
        hour = True
    elif begin.to('utc').time().minute != end.to('utc').time().minute :
        hour = True
    elif begin.to('utc').time().second != end.to('utc').time().second :
        hour = True
    elif begin.to('utc').time().hour in [ 22 , 23 , 0 ] and end.to('utc').time().hour in [ 22 , 23 , 0 ] :
        hour = False
    else :
        hour = True

    if hour :

        bf = 'YYYY, MMM DD, HH:mm'
        if begin.year == now.year:
            if begin.month == now.month:
                if begin.day == now.day:
                    bf = 'HH:mm'
                else :
                    bf = 'ddd DD, HH:mm'
            else:
                bf = 'MMM DD, HH:mm'

        ef = 'YYYY, MMM DD, HH:mm'
        if end.year == begin.year:
            if end.month == begin.month:
                if end.day == begin.day:
                    ef = 'HH:mm'
                else:
                    ef = 'DD, HH:mm'
            else:
                ef = 'MMM DD, HH:mm'

    else :

        bf = 'YYYY, MMM DD'
        if begin.year == now.year:
            if begin.month == now.month:
                if begin.day == now.day:
                    bf = 'HH:mm'
                else :
                    bf = 'ddd DD'
            else:
                bf = 'MMM DD'

        ef = 'YYYY, MMM DD'
        if end - begin < datetime.timedelta(365) :
            if end.month == begin.month:
                ef = 'DD'
            else:
                ef = 'MMM DD'

    return begin.format( bf ) + ' - ' + end.format( ef )

def calendars ( config = CONFIG ) :
    with open(config, 'r') as fd:
        return list(filter(lambda c: not c.get('hide'), json.load( fd )['calendars']))

def load ( calendars , cache = CACHE ) :
    calendar = ics.Calendar()
    calendar.events.update(_cache_load_calendars(calendars, cache = cache))
    return calendar

def _cache_load_calendars ( calendars , cache ) :
    for _calendar in calendars:
        yield from _cache_load_url(cache, _calendar['url'])

def url_hash ( url ) :
    return hashlib.sha1(url.encode()).hexdigest()

def _cache_load_url ( cache , url ) :

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


def _match(it, text):
    for line in it:
        if line == text : break

def _dropalarms(string):
    it = iter(string.splitlines())
    for line in it:
        if line == 'BEGIN:VALARM' : _match(it, 'END:VALARM')
        else: yield line

def dropalarms(string):
    return '\n'.join(_dropalarms(string))
