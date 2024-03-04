from create_database_utils import *
from diagnostics_test_utils import *
from buildless_test_utils import *

run_codeql_database_create([], lang="java", extra_env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true", "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true"})

check_diagnostics()
check_buildless_fetches()
