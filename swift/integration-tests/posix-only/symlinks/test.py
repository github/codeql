from create_database_utils import *
import os

symlinks = ['preserve/Sources/A.swift', 'resolve/Sources/A.swift']

for s in symlinks:
    try:
        os.symlink(os.getcwd() + '/main.swift', s)
    except:
        pass

run_codeql_database_create([
    'swift package clean --package-path resolve',
    'swift build --package-path resolve',
    'swift package clean --package-path preserve',
    'env CODEQL_PRESERVE_SYMLINKS=true swift build --package-path preserve'
], lang='swift', keep_trap=True)

for s in symlinks:
    os.unlink(s)
