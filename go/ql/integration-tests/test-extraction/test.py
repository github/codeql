import os
from pathlib import Path

import pytest

def test_traced(codeql, go):
    codeql.database.create(source_root="src", command="go test -c ./...")

def test_autobuild(codeql, go):
    codeql.database.create(source_root="src", extractor_option = ["extract_tests=true"])

def test_autobuild_traced(codeql, go):
    # Autobuild under build tracing must produce the same database as untraced
    # autobuild and explicit traced builds, all checked against test.expected.
    codeql.database.create(
        source_root="src",
        extractor_option = ["extract_tests=true"],
        _env={"CODEQL_EXTRACTOR_GO_BUILD_TRACING": "on"},
    )

@pytest.mark.parametrize("env", [
    {},
    {
        "CODEQL_EXTRACTOR_GO_BUILD_COMMAND": "echo built > custom-build-ran",
        "LGTM_INDEX_BUILD_COMMAND": "echo built > legacy-build-ran",
        "CODEQL_EXTRACTOR_GO_BUILD_TRACING": "on",
    },
])
def test_no_build(codeql, go, env):
    Path("src/Makefile").write_text("all:\n\techo built > project-build-ran\n")
    codeql.database.create(
        source_root="src",
        build_mode="none",
        extractor_option=["extract_tests=true"],
        _env=env,
    )
    for marker in ["project-build-ran", "custom-build-ran", "legacy-build-ran"]:
        assert not Path("src", marker).exists()
