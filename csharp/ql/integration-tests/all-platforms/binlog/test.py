import subprocess
from create_database_utils import *
from diagnostics_test_utils import *

subprocess.check_call(["dotnet", "build", "test.sln", "/bl:test.binlog"])
run_codeql_database_create([], lang="csharp", extra_args=["--build-mode=none", "-Obinlog=test.binlog"])
check_diagnostics()
