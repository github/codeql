import os

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
