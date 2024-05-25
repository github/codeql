from create_database_utils import *
from toolchains_test_utils import *

try_use_java11()

toolchains_file = actions_expose_all_toolchains()

run_codeql_database_create([], lang="java", extra_env={"LGTM_INDEX_MAVEN_TOOLCHAINS_FILE": toolchains_file})
