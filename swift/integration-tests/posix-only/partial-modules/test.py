from create_database_utils import *

run_codeql_database_create([
    'env',
    'swift package clean',
    'swift build -enable-incremental-imports'
], lang='swift', keep_trap=True)
