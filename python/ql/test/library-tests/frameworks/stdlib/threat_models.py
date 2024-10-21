import os
import sys
import posix

ensure_tainted(
    os.getenv("foo"), # $ tainted threatModelSource[environment]=os.getenv(..)
    os.getenvb("bar"), # $ tainted threatModelSource[environment]=os.getenvb(..)

    os.environ["foo"], # $ tainted threatModelSource[environment]=os.environ
    os.environ.get("foo"), # $ tainted threatModelSource[environment]=os.environ

    os.environb["bar"], # $ tainted threatModelSource[environment]=os.environb
    posix.environ[b"foo"], # $ tainted threatModelSource[environment]=posix.environ


    sys.argv[1], # $ tainted threatModelSource[commandargs]=sys.argv
    sys.orig_argv[1], # $ tainted threatModelSource[commandargs]=sys.orig_argv
)

for k,v in os.environ.items(): # $ threatModelSource[environment]=os.environ
    ensure_tainted(k) # $ tainted
    ensure_tainted(v) # $ tainted


########################################
# argparse
########################################

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("foo")

args = parser.parse_args() # $ threatModelSource[commandargs]=parser.parse_args()
ensure_tainted(args.foo) # $ tainted

explicit_argv_parsing = parser.parse_args(sys.argv) # $ threatModelSource[commandargs]=sys.argv
ensure_tainted(explicit_argv_parsing.foo) # $ tainted

fake_args = parser.parse_args(["<foo>"])
ensure_not_tainted(fake_args.foo)

########################################
# reading input from stdin
########################################

ensure_tainted(
    sys.stdin.readline(), # $ tainted threatModelSource[stdin]=sys.stdin
    input(), # $ tainted threatModelSource[stdin]=input()
)

########################################
# reading data from files
########################################

ensure_tainted(
    open("foo"), # $ tainted threatModelSource[file]=open(..) getAPathArgument="foo"
    open("foo").read(), # $ tainted threatModelSource[file]=open(..) getAPathArgument="foo"
    open("foo").readline(), # $ tainted threatModelSource[file]=open(..) getAPathArgument="foo"
    open("foo").readlines(), # $ tainted threatModelSource[file]=open(..) getAPathArgument="foo"

    os.read(os.open("foo"), 1024), # $ tainted threatModelSource[file]=os.read(..) getAPathArgument="foo"
)

########################################
# socket
########################################

import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("example.com", 1234))
ensure_tainted(s.recv(1024)) # $ MISSING: tainted threatModelSource[socket]
