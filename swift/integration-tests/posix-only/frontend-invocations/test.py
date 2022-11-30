from create_database_utils import *

import platform

run_codeql_database_create([
    './build.sh',
], lang='swift')
