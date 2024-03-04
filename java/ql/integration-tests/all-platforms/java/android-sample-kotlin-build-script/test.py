import sys

from create_database_utils import *

try_use_java11()

run_codeql_database_create([], lang="java")
