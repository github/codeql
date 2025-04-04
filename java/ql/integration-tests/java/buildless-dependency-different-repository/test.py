import subprocess
import logging
import runs_on


def test(codeql, java):
    # Each of these serves the "repo" and "repo2" directories on http://localhost:924[89]
    command1 = ["python3", "-m", "http.server", "9428"]
    command2 = ["python3", "-m", "http.server", "9429"]
    if runs_on.github_actions and runs_on.posix:
        # On GitHub Actions, we try to run the server with higher priority
        sudo_prefix = ["sudo", "nice", "-n", "10"]
        command1 = sudo_prefix + command1
        command2 = sudo_prefix + command2
    repo_server_process = subprocess.Popen(
        command1, cwd="repo"
    )
    repo_server_process2 = subprocess.Popen(
        command2, cwd="repo"
    )
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
