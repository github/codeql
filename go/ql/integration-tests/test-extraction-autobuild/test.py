import os

def test(codeql, go):
    codeql.database.create(source_root="src", extractor_option = ["extract_tests=true"])
