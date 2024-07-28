import sys

from create_database_utils import *
from maven_wrapper_test_utils import *

run_codeql_database_create([], lang="java")
check_maven_wrapper_exists("3.9.4")
