from create_database_utils import *
from diagnostics_test_utils import *
from buildless_test_utils import *

run_codeql_database_create([], lang="java", extra_args=["--build-mode=none"])

check_diagnostics()
check_buildless_fetches()
