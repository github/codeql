from create_database_utils import *

run_codeql_database_create([], lang="csharp", extra_args=["--extractor-option=cil=false"])
