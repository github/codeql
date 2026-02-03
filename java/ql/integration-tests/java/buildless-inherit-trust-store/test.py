"""
Integration tests for truststore inheritance and merging.

Tests that CodeQL can connect to HTTPS servers with custom CA certificates:
1. test_buildless: Buildless mode inherits truststore from MAVEN_OPTS
2. test_autobuild_merge_trust_store: Autobuild merges system truststore with
   CODEQL_PROXY_CA_CERTIFICATE (fixes github/codeql-team#4482)
"""
import subprocess
import os
import pytest
import runs_on
from contextlib import contextmanager


@contextmanager
def _https_server(cwd):
    """Start an HTTPS server serving the repo/ directory on https://localhost:4443."""
    command = ["python3", "../server.py"]
    if runs_on.github_actions and runs_on.posix:
        # On GitHub Actions, we saw the server timing out while running in parallel with other tests
        # we work around that by running it with higher permissions
        command = ["sudo"] + command
    repo_server_process = subprocess.Popen(command, cwd="repo")
    try:
        yield
    finally:
        repo_server_process.kill()


@pytest.mark.ql_test(expected=".buildless.expected")
def test_buildless(codeql, java, cwd, check_diagnostics, check_buildless_fetches):
    """Test that buildless mode inherits truststore from MAVEN_OPTS."""
    # Use buildless-specific expected file suffixes
    check_diagnostics.expected_suffix = ".buildless.expected"
    check_buildless_fetches.expected_suffix = ".buildless.expected"

    with _https_server(cwd):
        certspath = cwd / "jdk8_shipped_cacerts_plus_cert_pem"
        # If we override MAVEN_OPTS, we'll break cross-test maven isolation, so we need to append to it instead
        maven_opts = os.environ["MAVEN_OPTS"] + f" -Djavax.net.ssl.trustStore={certspath}"

        codeql.database.create(
            extractor_option="buildless=true",
            _env={
                "MAVEN_OPTS": maven_opts,
                "CODEQL_JAVA_EXTRACTOR_TRUST_STORE_PATH": str(certspath),
            },
        )


@pytest.mark.ql_test(expected=".autobuild.expected")
def test_autobuild_merge_trust_store(codeql, java, cwd, check_diagnostics):
    """
    Test that autobuild merges system truststore with CODEQL_PROXY_CA_CERTIFICATE.

    This tests the fix for a bug where autobuild was overriding JAVA_TOOL_OPTIONS
    truststore with a new one containing only the proxy CA, causing PKIX failures
    when connecting to internal HTTPS servers.
    """
    # Use autobuild-specific expected file suffix
    check_diagnostics.expected_suffix = ".autobuild.expected"

    with _https_server(cwd):
        certspath = cwd / "jdk8_shipped_cacerts_plus_cert_pem"

        # Read the certificate to use as CODEQL_PROXY_CA_CERTIFICATE
        with open(cwd / "cert.pem", "r") as f:
            proxy_ca_cert = f.read()

        # Set JAVA_TOOL_OPTIONS to use our custom truststore
        # This is the key setting that was being overridden before the fix
        java_tool_options = f"-Djavax.net.ssl.trustStore={certspath}"

        # Run autobuild with the truststore configured
        # Before the fix: autobuild would create a new truststore with ONLY the proxy CA,
        #                 losing the custom CA from JAVA_TOOL_OPTIONS, causing PKIX failures
        # After the fix:  autobuild merges the system truststore + proxy CA
        codeql.database.create(
            build_mode="autobuild",
            _env={
                "JAVA_TOOL_OPTIONS": java_tool_options,
                "CODEQL_PROXY_CA_CERTIFICATE": proxy_ca_cert,
            },
        )
