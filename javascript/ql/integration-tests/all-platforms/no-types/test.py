from create_database_utils import *

run_codeql_database_create([], lang="javascript", extra_env={"CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_SKIP_TYPES": "true"})
