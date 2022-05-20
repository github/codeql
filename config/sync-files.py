#!/usr/bin/env python3

# Due to various technical limitations, we sometimes have files that need to be
# kept identical in the repository. This script loads a database of such
# files and can perform two functions: check whether they are still identical,
# and overwrite the others with a master copy if needed.

import hashlib
import shutil
import os
import sys
import json
import re
path = os.path

file_groups = {}

def add_prefix(prefix, relative):
    result = path.join(prefix, relative)
    if path.commonprefix((path.realpath(result), path.realpath(prefix))) != \
            path.realpath(prefix):
        raise Exception("Path {} is not below {}".format(
            result, prefix))
    return result

def load_if_exists(prefix, json_file_relative):
    json_file_name = path.join(prefix, json_file_relative)
    if path.isfile(json_file_name):
        print("Loading file groups from", json_file_name)
        with open(json_file_name, 'r', encoding='utf-8') as fp:
            raw_groups = json.load(fp)
        prefixed_groups = {
                name: [
                    add_prefix(prefix, relative)
                    for relative in relatives
                ]
                for name, relatives in raw_groups.items()
            }
        file_groups.update(prefixed_groups)

# Generates a list of C# test files that should be in sync
def csharp_test_files():
    test_file_re = re.compile('.*(Bad|Good)[0-9]*\\.cs$')
    csharp_doc_files = {
        file:os.path.join(root, file)
            for root, dirs, files in os.walk("csharp/ql/src")
            for file in files
            if test_file_re.match(file)
    }
    return {
        "C# test '" + file + "'" : [os.path.join(root, file), csharp_doc_files[file]]
            for root, dirs, files in os.walk("csharp/ql/test")
            for file in files
            if file in csharp_doc_files
    }

def file_checksum(filename):
    with open(filename, 'rb') as file_handle:
        return hashlib.sha1(file_handle.read()).hexdigest()

def check_group(group_name, files, master_file_picker, emit_error):
    extant_files = [f for f in files if path.isfile(f)]
    if len(extant_files) == 0:
        emit_error(__file__, 0, "No files found from group '" + group_name + "'.")
        emit_error(__file__, 0,
                "Create one of the following files, and then run this script with "
                "the --latest switch to sync it to the other file locations.")
        for filename in files:
            emit_error(__file__, 0, "    " + filename)
        return

    checksums = {file_checksum(f) for f in extant_files}

    if len(checksums) == 1 and len(extant_files) == len(files):
        # All files are present and identical.
        return

    master_file = master_file_picker(extant_files)
    if master_file is None:
        emit_error(__file__, 0,
                "Files from group '"+ group_name +"' not in sync.")
        emit_error(__file__, 0,
                "Run this script with a file-name argument among the "
                "following to overwrite the remaining files with the contents "
                "of that file, or run with the --latest switch to update each "
                "group of files from the most recently modified file in the group.")
        for filename in extant_files:
            emit_error(__file__, 0, "    " + filename)
    else:
        print("  Syncing others from", master_file)
        for filename in files:
            if filename == master_file:
                continue
            print("    " + filename)
            if path.isfile(filename):
                os.replace(filename, filename + '~')
            shutil.copy(master_file, filename)
        print("  Backups written with '~' appended to file names")

def chdir_repo_root():
    root_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
    os.chdir(root_path)

def choose_master_file(master_file, files):
    if master_file in files:
        return master_file
    else:
        return None

def choose_latest_file(files):
    latest_time = None
    latest_file = None
    for filename in files:
        file_time = os.path.getmtime(filename)
        if (latest_time is None) or (latest_time < file_time):
            latest_time = file_time
            latest_file = filename
    return latest_file

local_error_count = 0
def emit_local_error(path, line, error):
    print('ERROR: ' + path + ':' + str(line) + " - " + error)
    global local_error_count
    local_error_count += 1

# This function is invoked directly by a CI script, which passes a different error-handling
# callback.
def sync_identical_files(emit_error):
    if len(sys.argv) == 1:
        master_file_picker = lambda files: None
    elif len(sys.argv) == 2:
        if sys.argv[1] == "--latest":
            master_file_picker = choose_latest_file
        elif os.path.isfile(sys.argv[1]):
            master_file_picker = lambda files: choose_master_file(sys.argv[1], files)
        else:
            raise Exception("File not found")
    else:
        raise Exception("Bad command line or file not found")
    chdir_repo_root()
    load_if_exists('.', 'config/identical-files.json')
    file_groups.update(csharp_test_files())
    for group_name, files in file_groups.items():
        check_group(group_name, files, master_file_picker, emit_error)

def main():
    sync_identical_files(emit_local_error)
    if local_error_count > 0:
        exit(1)

if __name__ == "__main__":
    main()
