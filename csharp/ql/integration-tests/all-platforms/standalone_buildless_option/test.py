import os
from create_database_utils import *
from diagnostics_test_utils import *

os.environ['CODEQL_EXTRACTOR_CSHARP_OPTION_BUILDLESS'] = 'true'
run_codeql_database_create([], lang="csharp")

check_diagnostics()
