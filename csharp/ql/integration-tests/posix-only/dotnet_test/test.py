from create_database_utils import *

run_codeql_database_create(['dotnet test'], test_db="default-db", db=None, lang="csharp")