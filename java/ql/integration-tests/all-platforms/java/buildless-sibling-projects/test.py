from create_database_utils import *
from diagnostics_test_utils import *
from buildless_test_utils import *
from toolchains_test_utils import *

#The version of gradle used doesn't work on java 17
try_use_java11()

toolchains_file = actions_expose_all_toolchains()

run_codeql_database_create([], lang="java", extra_env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true", "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true", "LGTM_INDEX_MAVEN_TOOLCHAINS_FILE": toolchains_file})

check_diagnostics()
check_buildless_fetches()
