#!/usr/bin/python2

import os
from urlparse import urlparse
import argparse

def str2bool(v):
  if isinstance(v, bool):
    return v
  if v.lower() in ('yes', 'true', 't', 'y', '1'):
    return True
  elif v.lower() in ('no', 'false', 'f', 'n', '0'):
    return False
  else:
    raise argparse.ArgumentTypeError('Boolean value expected.')

parser = argparse.ArgumentParser(description='Adapt Nev Vars for heroku Postgres.')
parser.add_argument("--passfile", type=str2bool, nargs='?',
                        const=True, default=False,
                        help="Activate passfile mode.")
args = parser.parse_args()

if ('DATABASE_URL' in os.environ):
  uri = os.environ['DATABASE_URL']
  result = urlparse(uri)
  userpass, hostport = result.netloc.split('@')
  user, passwd = userpass.split(':')
  host, port = hostport.split(':')
  name = result.path.replace('/', '')

  if (args.passfile):
    print (host+":"+port+":"+name+":"+user+":"+passwd)
  else:
    print("--postgresql --db-host "+host+" --db-port "+port+" --db-username "+user+" --db-name "+name)
else:
  print("")
