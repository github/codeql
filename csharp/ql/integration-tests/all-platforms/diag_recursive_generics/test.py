from create_database_utils import *

run_codeql_database_create(['dotnet build'], lang="csharp", extra_args=["--extractor-option=cil=false"])
