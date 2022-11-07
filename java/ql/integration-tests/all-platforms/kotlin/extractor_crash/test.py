import sys

from create_database_utils import *

run_codeql_database_create(
        ['"%s" build.py' % sys.executable],
        source="code", lang="java")
