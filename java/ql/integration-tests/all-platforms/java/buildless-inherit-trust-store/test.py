import subprocess
import os


def test(codeql, java, cwd):
    # This serves the "repo" directory on https://locahost:4443
    repo_server_process = subprocess.Popen(["python3", "../server.py"], cwd="repo")
    certspath = cwd / "jdk8_shipped_cacerts_plus_cert_pem"
    # If we override MAVEN_OPTS, we'll break cross-test maven isolation, so we need to append to it instead
    maven_opts = os.environ["MAVEN_OPTS"] + f" -Djavax.net.ssl.trustStore={certspath}"

    try:
        codeql.database.create(
            extractor_option="buildless=true",
            _env={
                "MAVEN_OPTS": maven_opts,
                "CODEQL_JAVA_EXTRACTOR_TRUST_STORE_PATH": str(certspath),
            },
        )
    finally:
        repo_server_process.kill()
