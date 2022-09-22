from create_database_utils import *

# no arguments
run_codeql_database_create(['dotnet run'], test_db="test-db", db=None, lang="csharp")

# no arguments, but `--`
run_codeql_database_create(['dotnet clean', 'rm -rf test-db', 'dotnet run --'], test_db="test2-db", db=None, lang="csharp")

# two arguments, no `--`
run_codeql_database_create(['dotnet clean', 'rm -rf test2-db', 'dotnet run hello world'], test_db="test3-db", db=None, lang="csharp")

# two arguments, and `--`
run_codeql_database_create(['dotnet clean', 'rm -rf test3-db', 'dotnet run -- hello world'], test_db="test4-db", db=None, lang="csharp")

# shared compilation enabled; tracer should override by changing the command
# to `dotnet run -p:UseSharedCompilation=true -p:UseSharedCompilation=false -- hello world`
run_codeql_database_create(['dotnet clean', 'rm -rf test4-db', 'dotnet run -p:UseSharedCompilation=true -- hello world'], test_db="test5-db", db=None, lang="csharp")
