import os
import sys

from create_database_utils import *

os.environ['LGTM_INDEX_IMPORT_PATH'] = "deptest"
run_codeql_database_create([], lang="go", source="work")
