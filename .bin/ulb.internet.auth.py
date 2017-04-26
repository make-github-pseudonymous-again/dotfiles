#!/usr/bin/env python3

import urllib.request
import urllib.parse
import socket
import ssl
import http.client
import getpass
import subprocess

URL = 'https://172.19.78.1/web_auth/index.html'

HEADERS = {
    'Host': '172.19.78.1',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:41.0) Gecko/20100101 Firefox/41.0',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Referer': 'https://172.19.78.1/web_auth',
    'Connection': 'keep-alive'
}

CONTEXT = ssl.create_default_context(ssl.Purpose.SERVER_AUTH)
CONTEXT.check_hostname = False
CONTEXT.verify_mode = ssl.CERT_NONE

username = None
password = None

try:

    up = subprocess.run(['pass', 'ULB/ethernet/user'],stdout=subprocess.PIPE)
    if up.returncode == 0 :
        username = up.stdout.decode('utf-8')[:-1]

        pp = subprocess.run(['pass', 'ULB/ethernet/login'],stdout=subprocess.PIPE)
        if pp.returncode == 0 :
            password = pp.stdout.decode('utf-8')[:-1]

except FileNotFoundError :
    pass

if username is None or password is None :
    username = input('username: ')
    password = getpass.getpass('password: ')

while True:

    values = {'edit_cookies': '',
              'admin_id': username,
              'admin_pw': password}

    data = urllib.parse.urlencode(values)
    data = data.encode('utf-8')
    req = urllib.request.Request(URL, data, HEADERS)

    with urllib.request.urlopen(req, context=CONTEXT) as response:
        if 'Success' in response.read().decode():
            print('connected')
            break
        else:
            print('bad credentials')

    username = input('username: ')
    password = getpass.getpass('password: ')
