from create_database_utils import *
from diagnostics_test_utils import *

def run_codeql_database_create_stdout(args, dbname):
    stdout = open(dbname + "file.txt", 'w+')
    run_codeql_database_create(args, test_db=dbname, db=None, stdout=stdout, lang="csharp")
    stdout.seek(0)
    s = stdout.read()
    stdout.close()
    return s

def check_build_out(msg, s):
    if "[build-stdout] " + msg not in s:
        raise Exception("The C# extractor did not interpret the 'dotnet run' command correctly")

# no arguments
s = run_codeql_database_create_stdout(['dotnet run'], "test-db")
check_build_out("Default reply", s)
check_diagnostics()

# no arguments, but `--`
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test-db', 'dotnet run --'], "test2-db")
check_build_out("Default reply", s)
check_diagnostics(test_db="test2-db")

# one argument, no `--`
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test2-db', 'dotnet run hello'], "test3-db")
check_build_out("Default reply", s)
check_diagnostics(test_db="test3-db")

# one argument, but `--`
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test3-db', 'dotnet run -- hello'], "test4-db")
check_build_out("Default reply", s)
check_diagnostics(test_db="test4-db")

# two arguments, no `--`
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test4-db', 'dotnet run hello world'], "test5-db")
check_build_out("hello, world", s)
check_diagnostics(test_db="test5-db")

# two arguments, and `--`
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test5-db', 'dotnet run -- hello world'], "test6-db")
check_build_out("hello, world", s)
check_diagnostics(test_db="test6-db")

# shared compilation enabled; tracer should override by changing the command
# to `dotnet run -p:UseSharedCompilation=true -p:UseSharedCompilation=false -- hello world`
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test6-db', 'dotnet run -p:UseSharedCompilation=true -- hello world'], "test7-db")
check_build_out("hello, world", s)
check_diagnostics(test_db="test7-db")

# option passed into `dotnet run`
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test7-db', 'dotnet build', 'dotnet run --no-build hello world'], "test8-db")
check_build_out("hello, world", s)
check_diagnostics(test_db="test8-db")

# two arguments, no '--' (first argument quoted)
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test8-db', 'dotnet run "hello world part1" part2'], "test9-db")
check_build_out("hello world part1, part2", s)
check_diagnostics(test_db="test9-db")

# two arguments, no '--' (second argument quoted) and using dotnet to execute dotnet
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test9-db', 'dotnet dotnet run part1 "hello world part2"'], "test10-db")
check_build_out("part1, hello world part2", s)
check_diagnostics(test_db="test10-db")
