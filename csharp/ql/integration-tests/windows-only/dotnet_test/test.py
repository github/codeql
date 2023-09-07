from create_database_utils import *
from diagnostics_test_utils import *

# Implicitly build and then run tests.
run_codeql_database_create(['dotnet test'], test_db="test-db", lang="csharp")
check_diagnostics()

# Explicitly build and then run tests.
run_codeql_database_create(['dotnet clean', 'rm -rf test-db', 'dotnet build -o myout', 'dotnet test myout/dotnet_test.dll'], test_db="test2-db", lang="csharp")
check_diagnostics(test_db="test2-db")
