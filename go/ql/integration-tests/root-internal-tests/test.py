import os

def test(codeql, go):
    # Test that root internal test files are extracted when nested packages have tests
    codeql.database.create(source_root="src", extractor_option = ["extract_tests=true"])
