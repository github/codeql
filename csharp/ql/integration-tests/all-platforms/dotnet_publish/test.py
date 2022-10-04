import os
from create_database_utils import *

run_codeql_database_create(['dotnet publish'], test_db="default-db", db=None, lang="csharp")

## Check that the publish folder is created.
if not os.path.isdir("bin/Debug/net6.0/publish/"):
    raise Exception("The publish artifact folder was not created.") 
