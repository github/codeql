from create_database_utils import *
from diagnostics_test_utils import *
import os

os.environ["PROJECT_TO_BUILD"] = "proj.csproj.no_auto"

run_codeql_database_create([], db=None, lang="csharp")
check_diagnostics()
