import sys

from create_database_utils import *

#The version of gradle used doesn't work on java 17
try_use_java11()

run_codeql_database_create([], lang="java")
