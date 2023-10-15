import sys

from create_database_utils import *
from diagnostics_test_utils import *

run_codeql_database_create([], lang="java", extra_env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true"})

check_diagnostics()
