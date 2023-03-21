import os
from create_database_utils import *
from diagnostics_test_utils import *

artifacts = 'bin/Temp'
run_codeql_database_create([f"dotnet publish -o {artifacts}"], db=None, lang="csharp")

## Check that the publish folder is created.
if not os.path.isdir(artifacts):
    raise Exception("The publish artifact folder was not created.")

check_diagnostics()
