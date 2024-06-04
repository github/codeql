import sys

from create_database_utils import *
from buildless_test_utils import *
from diagnostics_test_utils import *
import subprocess
import os.path

# This serves the "repo" directory on https://locahost:4443
repo_server_process = subprocess.Popen(["python3", "../server.py"], cwd = "repo")

mypath = os.path.abspath(os.path.dirname(__file__))
certspath = os.path.join(mypath, "jdk8_shipped_cacerts_plus_cert_pem")
maven_certs_option = "-Djavax.net.ssl.trustStore=" + certspath

try:
  run_codeql_database_create([], lang="java", extra_args=["--build-mode=none"], extra_env={"MAVEN_OPTS": maven_certs_option, "CODEQL_JAVA_EXTRACTOR_TRUST_STORE_PATH": certspath})
finally:
  repo_server_process.kill()

check_buildless_fetches()
check_diagnostics()
