# All functions starting with "test_" should run and execute `print("OK")` exactly once.
# This can be checked by running validTest.py.

import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"


def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):
    if is_source(x):
        print("OK")
    else:
        print("Unexpected flow", x)


def SINK_F(x):
    if is_source(x):
        print("Unexpected flow", x)
    else:
        print("OK")

# ------------------------------------------------------------------------------
# Actual tests
# ------------------------------------------------------------------------------

def read_sql(sql):
    SINK(sql) # $ flow="SOURCE, l:+5 -> sql"

def process(func, arg): 
    func(arg) 

process(func=read_sql, arg=SOURCE)


def read_sql_star(sql):
    SINK(sql) # $ MISSING: flow="SOURCE, l:+5 -> sql"

def process_star(func, *args): 
    func(*args) 

process_star(read_sql_star, SOURCE)


def read_sql_dict(sql):
    SINK(sql) # $ flow="SOURCE, l:+5 -> sql"

def process_dict(func, **args): 
    func(**args) 

process_dict(func=read_sql_dict, sql=SOURCE)


# TODO:
# Consider adding tests for
# threading.Thread, multiprocess.Process,
# concurrent.futures.ThreadPoolExecutor,
# and concurrent.futures.ProcessPoolExecutor.
