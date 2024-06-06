import sys

from create_database_utils import *
from diagnostics_test_utils import *

# gradlew has been rigged to stall for a long time by trying to fetch from a black-hole IP. We should find the timeout logic fires and buildless aborts the Gradle run quickly.

run_codeql_database_create([], lang="java", extra_args=["--build-mode=none"], extra_env={"CODEQL_EXTRACTOR_JAVA_BUILDLESS_CHILD_PROCESS_IDLE_TIMEOUT": "5"})
check_diagnostics()
