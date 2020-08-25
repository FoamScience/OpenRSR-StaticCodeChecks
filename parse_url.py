#!/usr/bin/python2

import os
from urlparse import urlparse

uri = os.environ['DATABASE_URL']
result = urlparse(uri)
userpass, hostport = result.netloc.split('@')
user, passwd = userpass.split(':')
host, port = hostport.split(':')
name = result.path.replace('/', '')

if ('DATABASE_URL' in os.environ):
    print("--postgresql --db-host "+host+" --db-port "+port+" --db-username "+user+" --db-name "+name)
else:
    print("")
