import sys

from create_database_utils import *
from buildless_test_utils import *
import subprocess

repo_server_process = subprocess.Popen(["python3", "-m", "http.server", "9428"], cwd = "repo")
repo_server_process2 = subprocess.Popen(["python3", "-m", "http.server", "9429"], cwd = "repo2")

try:
  run_codeql_database_create([], lang="java", extra_args=["--extractor-option=buildless=true"], extra_env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true"})
finally:
  try:
    repo_server_process.kill()
  except Exception as e:
    print("Failed to kill server 1:", e, file = sys.stderr)
  repo_server_process2.kill()

check_buildless_fetches()
