from create_database_utils import *
import os

os.environ["PROJECT_TO_BUILD"] = "proj.csproj.no_auto"

run_codeql_database_create([], test_db="default-db", db=None, lang="csharp")
