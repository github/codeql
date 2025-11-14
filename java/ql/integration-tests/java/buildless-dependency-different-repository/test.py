import subprocess
import logging
import time
import socket


def wait_for_port(port, process, timeout=100):
    start = time.time()
    while time.time() - start < timeout:
        # Check if process died
        if process.poll() is not None:
            raise RuntimeError(f"Server process exited with code {process.returncode}")
        try:
            with socket.create_connection(("localhost", port), timeout=1):
                return True
        except (socket.timeout, ConnectionRefusedError, OSError):
            time.sleep(0.2)
    raise RuntimeError(f"Port {port} not ready within {timeout}s")


def test(codeql, java):
    repo_server_process = subprocess.Popen(["python3", "-m", "http.server", "9428", "-b", "localhost"], cwd="repo", stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    repo_server_process2 = subprocess.Popen(["python3", "-m", "http.server", "9429", "-b", "localhost"], cwd="repo2", stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    try:
        wait_for_port(9428, repo_server_process)
        wait_for_port(9429, repo_server_process2)
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
