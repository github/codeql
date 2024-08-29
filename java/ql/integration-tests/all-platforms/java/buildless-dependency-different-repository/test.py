import subprocess
import logging


def test(codeql, java):
    # Each of these serves the "repo" and "repo2" directories on http://localhost:924[89]
    repo_server_process = subprocess.Popen(["python3", "-m", "http.server", "9428"], cwd="repo")
    repo_server_process2 = subprocess.Popen(["python3", "-m", "http.server", "9429"], cwd="repo2")
    try:
        codeql.database.create(
            extractor_option="buildless=true",
            _env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true"},
        )
    finally:
        try:
            repo_server_process.kill()
        except Exception as e:
            logging.error("Failed to kill server 1:", e)
        repo_server_process2.kill()
