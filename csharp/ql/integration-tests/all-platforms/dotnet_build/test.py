from create_database_utils import *
from diagnostics_test_utils import *

def check_build_out(msg, s):
    if "[build-stdout] " + msg not in s:
        raise Exception("The C# tracer did not interpret the dotnet path-to-application command correctly.")

run_codeql_database_create(['dotnet build'], test_db="test1-db", lang="csharp")
check_diagnostics(test_db="test1-db")

# This test checks that we don't inject any flags when running the application using `dotnet`
my_dir = "my_program"
my_abs_path = os.path.abspath(f"{my_dir}/dotnet_build.dll")
s = run_codeql_database_create_stdout(['dotnet clean', 'rm -rf test1-db', 'dotnet build -o my_program', f'dotnet {my_abs_path} build is not a subcommand'], "test2-db", "csharp")
check_build_out("<arguments>build,is,not,a,subcommand</arguments>", s)
check_diagnostics(test_db="test2-db")
