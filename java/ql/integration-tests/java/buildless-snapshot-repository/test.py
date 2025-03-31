import subprocess
import sys


def test(codeql, java):
    # This serves the "repo" directory on http://localhost:9427
    repo_server_process = subprocess.Popen(
        [sys.executable, "-m", "http.server", "9427"], cwd="repo"
    )
    try:
        subprocess.call(["curl", "-m", "30", "http://localhost:9427/snapshots"])
        subprocess.call(["curl", "-m", "30", "http://localhost:9427/snapshots/com/github/my/snapshot/test/snapshottest/1.0-SNAPSHOT/maven-metadata.xml"])
        codeql.database.create(
            extractor_option="buildless=true",
            _env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true"},
        )
    finally:
        subprocess.call(["ps", "aux", "-ww"])
        subprocess.call(["netstat", "-anv"])
        subprocess.call(["curl", "-m", "30", "http://localhost:9427/snapshots"])
        subprocess.call(["curl", "-m", "30", "http://localhost:9427/snapshots/com/github/my/snapshot/test/snapshottest/1.0-SNAPSHOT/maven-metadata.xml"])
        repo_server_process.kill()
