import os
from create_database_utils import *

os.environ['CODEQL_EXTRACTOR_CSHARP_BUILDLESS_EXTRACT_WEB_VIEWS'] = 'false'
run_codeql_database_create(lang="csharp", extra_args=["--build-mode=none"])
