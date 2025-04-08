import subprocess
import runs_on


def test(codeql, java):
    # This serves the "repo" directory on http://localhost:9427
    command = ["python3", "-m", "http.server", "9427", "-b", "localhost"]
    if runs_on.github_actions and runs_on.posix:
        # On GitHub Actions, we try to run the server with higher priority
        command = ["sudo"] + command
    repo_server_process = subprocess.Popen(
        command, cwd="repo"
    )
    try:
        codeql.database.create(
            extractor_option="buildless=true",
            _env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true"},
        )
    finally:
        repo_server_process.kill()
