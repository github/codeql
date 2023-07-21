from create_database_utils import *
from diagnostics_test_utils import *

run_codeql_database_create([], db=None, lang="csharp", runFunction=runUnsuccessfully)
check_diagnostics()
