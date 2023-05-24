import os
from create_database_utils import *
from diagnostics_test_utils import *

run_codeql_database_create(["./build.sh"], lang="csharp", extra_args=["--extractor-option=cil=false"])

check_diagnostics()
