#!/usr/bin/env python3

import re
import functools
import subprocess
import urllib.request

# from https://github.com/kennethreitz/requests
def parse_header_links(value):
    """Return a dict of parsed link headers proxies.
    i.e. Link: <http:/.../front.jpeg>; rel=front; type="image/jpeg",<http://.../back.jpeg>; rel=back;type="image/jpeg"
    :rtype: list
    """

    replace_chars = ' \'"'

    for val in re.split(', *<', value):
        try:
            url, params = val.split(';', 1)
        except ValueError:
            url, params = val, ''

        link = {'url': url.strip('<> \'"')}

        for param in params.split(';'):
            try:
                key, value = param.split('=')
            except ValueError:
                break

            link[key.strip(replace_chars)] = value.strip(replace_chars)

        yield link

def next_url ( info ) :
    header = dict(info)
    header_link = header['link']
    header_link_next = next(filter(lambda x: x['rel'] == 'next', parse_header_links(header_link)))
    return header_link_next['url']


def send ( url , token = None , **kwargs ) :
    req = urllib.request.Request(url, **kwargs)
    if token is not None:
        req.add_header('Authorization', 'token {}'.format(token))

    with urllib.request.urlopen(req) as connection:
        data = connection.read()
        info = connection.info()

    return data, info

def pages ( url , **kwargs ) :

    while True:

        data, info = send( url , **kwargs)
        yield data

        try:
            url = next_url(info)
        except KeyError:
            break
        except StopIteration:
            break

def api ( endpoint, *args, **kwargs ) :
    github_api = 'https://api.github.com'
    return github_api + endpoint.format(*args, **kwargs)

def token ( ) :
    p = subprocess.run(['pass', 'apps/github/pat'], stdout=subprocess.PIPE)
    if p.returncode == 0 :
        return p.stdout.decode('utf-8')[:-1]
    else:
        raise Exception('Could not find token')

PUT = "PUT"
GET = "GET"
POST = "POST"
PATCH = "PATCH"
UPDATE = "UPDATE"
DELETE = "DELETE"

put = functools.partial(send, method = PUT)
get = functools.partial(send, method = GET)
post = functools.partial(send, method = POST)
update = functools.partial(send, method = UPDATE)
patch = functools.partial(send, method = PATCH)
delete = functools.partial(send, method = DELETE)
