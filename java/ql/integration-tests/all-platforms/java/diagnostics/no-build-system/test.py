import os
from create_database_utils import *
from diagnostics_test_utils import *

os.mkdir("diagnostics")
run_codeql_database_create([], lang="java", runFunction = runUnsuccessfully, db = None, extra_env = {"CODEQL_EXTRACTOR_DIAGNOSTIC_DIR": "diagnostics"})

check_diagnostics(test_dir = ".", diagnostics_dir = "diagnostics")
