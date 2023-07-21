import os
from create_database_utils import *
from diagnostics_test_utils import *

run_codeql_database_create(['dotnet pack'], db=None, lang="csharp")

## Check that the NuGet package is created.
if not os.path.isfile("bin/Debug/dotnet_pack.1.0.0.nupkg"):
    raise Exception("The NuGet package was not created.")

check_diagnostics()
