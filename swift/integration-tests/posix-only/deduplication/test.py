from create_database_utils import *

run_codeql_database_create([
    'swift package clean',
    'swift build',
], lang='swift', keep_trap=True)
