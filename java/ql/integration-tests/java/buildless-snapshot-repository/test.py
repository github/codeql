import subprocess
import sys


def test(codeql, java):
    # This serves the "repo" directory on http://localhost:9427
    repo_server_process = subprocess.Popen(
        [sys.executable, "-m", "http.server", "9427"], cwd="repo"
    )
    try:
        codeql.database.create(
            extractor_option="buildless=true",
            _env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true"},
        )
    finally:
        repo_server_process.kill()
