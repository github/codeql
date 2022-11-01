from create_database_utils import *

run_codeql_database_create(['kotlinc test.kt'], test_db="kt-db", db=None, lang="java")
run_codeql_database_create(['"%s" ./index_logs.py' % sys.executable], lang="java")
