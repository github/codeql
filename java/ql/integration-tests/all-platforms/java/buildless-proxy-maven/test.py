from create_database_utils import *
from diagnostics_test_utils import *
from buildless_test_utils import *
import mitm_proxy
import os
import shutil
import subprocess
import sys

shutil.rmtree('certs', ignore_errors=True)
os.mkdir('certs')

ca_cert_file = 'certs/ca-cert.pem'
ca_key_file = 'certs/ca-key.pem'
mitm_proxy.generateCA(ca_cert_file, ca_key_file)
with open(ca_cert_file, 'rb') as f:
    cert_pem = f.read().decode('ascii')

# This starts an HTTP proxy server on http://localhost:9431
environment = os.environ.copy()
environment["PROXY_USER"] = "proxy"
environment["PROXY_PASSWORD"] = "password"

proxy_server_process = subprocess.Popen(
    [sys.executable, mitm_proxy.__file__, "9431", "certs/ca-cert.pem", "certs/ca-key.pem"], env=environment)

try:
    run_codeql_database_create([], lang="java", extra_env={
        "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true",
        "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true",
        "CODEQL_PROXY_HOST": "localhost",
        "CODEQL_PROXY_PORT": "9431",
        "CODEQL_PROXY_USER": "proxy",
        "CODEQL_PROXY_PASSWORD": "password",
        "CODEQL_PROXY_CA_CERTIFICATE": cert_pem
    })
finally:
    proxy_server_process.kill()
check_diagnostics()
check_buildless_fetches()
