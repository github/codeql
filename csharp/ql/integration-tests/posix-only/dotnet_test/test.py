from create_database_utils import *
from diagnostics_test_utils import *

run_codeql_database_create(['dotnet test'], db=None, lang="csharp")
check_diagnostics()
