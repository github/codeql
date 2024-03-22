from create_database_utils import *
from diagnostics_test_utils import *

run_codeql_database_create([], lang="csharp", extra_args=["--build-mode=none"])

check_diagnostics()