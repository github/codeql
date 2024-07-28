from create_database_utils import *
from diagnostics_test_utils import *

run_codeql_database_create([], lang='swift', keep_trap=True, db=None, runFunction=runUnsuccessfully)
check_diagnostics()
