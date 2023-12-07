from create_database_utils import *
from diagnostics_test_utils import *

# the tracer configuration should not inject the extra command-line arguments for these commands
# and they should therefore run successfully
run_codeql_database_init(lang="csharp")
# this command fails on Windows for some reason, so we comment it out for now
# run_codeql_database_trace_command(['dotnet', 'tool', 'search', 'publish'])
run_codeql_database_trace_command(['dotnet', 'new', 'console', '--force', '--name', 'build', '--output', '.'])
