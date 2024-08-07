from create_database_utils import *
import os

os.environ["CODEQL_EXTRACTOR_CSHARP_OPTION_TRAP_COMPRESSION"] = "none"

run_codeql_database_create(['dotnet build /p:DefineConstants=A', 'dotnet build /p:DefineConstants=B'], lang="csharp")
