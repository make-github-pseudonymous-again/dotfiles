#!/usr/bin/env python3

import re
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
    header_link = header['Link']
    header_link_next = next(filter(lambda x: x['rel'] == 'next', parse_header_links(header_link)))
    return header_link_next['url']

def pages ( url , credentials = None ) :

    while True:

        req = urllib.request.Request(url)
        if credentials is not None:
            req.add_header('Authorization', 'Basic %s' % credentials)

        with urllib.request.urlopen(req) as connection:
            data = connection.read()
            info = connection.info()
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
