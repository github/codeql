import os

def test_traced(codeql, go):
    codeql.database.create(source_root="src", command="go test -c ./...")

def test_autobuild(codeql, go):
    codeql.database.create(source_root="src", extractor_option = ["extract_tests=true"])
