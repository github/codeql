import os
import sys
import posix

os.getenv("foo") # $ threatModelSource[environment]=os.getenv(..)
os.getenvb("bar") # $ threatModelSource[environment]=os.getenvb(..)

os.environ["foo"] # $ threatModelSource[environment]=os.environ["foo"]
os.environ.get("foo") # $ MISSING: threatModelSource[environment]=os.environ.get(..)

os.environb["bar"] # $ threatModelSource[environment]=os.environb["bar"]
posix.environ[b"foo"] # $ threatModelSource[environment]=posix.environ[b"foo"]


sys.argv[1] # $ threatModelSource[commandargs]=sys.argv[1]
sys.orig_argv[1] # $ threatModelSource[commandargs]=sys.orig_argv[1]

########################################
# argparse
########################################

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("foo")

args = parser.parse_args()
args.foo # $ MISSING: threatModelSource[commandargs]=args.foo

explicit_argv_parsing = parser.parse_args(sys.argv)
explicit_argv_parsing.foo # $ MISSING: threatModelSource[commandargs]=explicit_argv_parsing.foo

fake_args = parser.parse_args(["<foo>"])
fake_args.foo

########################################
# reading input from stdin
########################################

sys.stdin.readline() # $ MISSING: threatModelSource
input() # $ MISSING: threatModelSource

########################################
# socket
########################################

import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("example.com", 1234))
s.recv(1024) # $ MISSING: threatModelSource[socket]
