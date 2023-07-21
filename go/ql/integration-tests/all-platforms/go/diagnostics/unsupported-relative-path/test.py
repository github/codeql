import sys

from create_database_utils import *
from diagnostics_test_utils import *

os.environ['GITHUB_REPOSITORY'] = "a/b"
run_codeql_database_create([], lang="go", source="work", db=None, runFunction=runUnsuccessfully)

check_diagnostics()
