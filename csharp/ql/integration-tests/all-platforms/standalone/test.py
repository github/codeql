import os
from create_database_utils import *
from diagnostics_test_utils import *

os.environ['CODEQL_EXTRACTOR_CSHARP_OPTION_COMPILER_DIAGNOSTIC_LIMIT'] = '2'
os.environ['CODEQL_EXTRACTOR_CSHARP_OPTION_MESSAGE_LIMIT'] = '5'
run_codeql_database_create([], lang="csharp", extra_args=["--build-mode=none"])

check_diagnostics()