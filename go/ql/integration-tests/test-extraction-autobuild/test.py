import os

def test(codeql, go):
    os.environ["CODEQL_EXTRACTOR_GO_EXTRACT_TESTS"] = "true"
    codeql.database.create(source_root="src")
