import sys

from create_database_utils import *
from buildless_test_utils import *
import subprocess

repo_server_process = subprocess.Popen(["python3", "-m", "http.server", "9427"], cwd = "repo")

try:
  run_codeql_database_create([], lang="java", extra_args=["--extractor-option=buildless=true"], extra_env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true"})
finally:
  repo_server_process.kill()

check_buildless_fetches()
