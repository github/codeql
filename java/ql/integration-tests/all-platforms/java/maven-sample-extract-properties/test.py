import sys

from create_database_utils import *

run_codeql_database_create([], lang="java", extra_env = {"LGTM_INDEX_PROPERTIES_FILES": "true"})
