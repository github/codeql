#!/usr/bin/env python3

# Due to various technical limitations, we sometimes have files that need to be
# kept identical in the repository. This script loads a database of such
# files and can perform two functions: check whether they are still identical,
# and overwrite the others with a master copy if needed.
# The script that does the actual work is `sync-files.py`, which lives in the `codeql` submodule.
import sys
import os

sys.path.append(os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../codeql/config')))

import importlib
syncfiles = importlib.import_module('sync-files')

def chdir_repo_root():
    root_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
    os.chdir(root_path)

def sync_identical_files():
    if len(sys.argv) == 1:
        master_file_picker = lambda files: None
    elif len(sys.argv) == 2:
        if sys.argv[1] == "--latest":
            master_file_picker = syncfiles.choose_latest_file
        elif os.path.isfile(sys.argv[1]):
            master_file_picker = lambda files: syncfiles.choose_master_file(sys.argv[1], files)
        else:
            raise Exception("File not found")
    else:
        raise Exception("Bad command line or file not found")
    chdir_repo_root()
    syncfiles.load_if_exists('.', 'scripts/identical-files.json')
    for group_name, files in syncfiles.file_groups.items():
        syncfiles.check_group(group_name, files, master_file_picker, syncfiles.emit_local_error)

def main():
    sync_identical_files()

    if syncfiles.local_error_count > 0:
        exit(1)
    else:
        print(__file__ +": All checks OK.")

if __name__ == "__main__":
    main()
