#!/usr/bin/env python3

import argparse
import logging
import os
import sqlite3

class EmptyNameError(Exception):
    pass

logging.basicConfig(force=True, encoding='utf-8', level=logging.INFO,
                    format='[%(asctime)s] %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

def get_user_info():
    print("*** Welcome to sql injection ***")
    print("Please enter name: ", end='', flush=True)
    info = input().strip()
    if info == "": raise EmptyNameError("get_user_info: expect non-empty name")
    return info

def get_new_id():
    id = os.getpid()
    return id

def write_info(id: int, info: str) -> None:
    # Open db
    conn = sqlite3.connect("users.sqlite")

    # Format query 
    query = "INSERT INTO users VALUES (%d, '%s')" % (id, info)

    # Write data
    conn.executescript(query)     # Unsafe, used for illustration
    logging.info("query: %s\n", query)

    # Finish up
    conn.commit()
    conn.close()

def add_user():
    # Command line interface
    parser = argparse.ArgumentParser(
        description="""A server-side interface to add users to the database.  
A single user name is read from stdin, actions are logged to stderr""",
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.parse_args()

    # Read and process input
    logging.info("Running add-user")
    info = get_user_info()
    id = get_new_id()
    write_info(id, info)

if __name__ == "__main__":
    add_user()
    
