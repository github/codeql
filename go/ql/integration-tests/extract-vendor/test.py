import os


def test(codeql, go):
    os.environ["CODEQL_EXTRACTOR_GO_EXTRACT_VENDOR_DIRS"] = "true"
    codeql.database.create(source_root="src")

def test_extractor_option(codeql, go):
    codeql.database.create(source_root="src", extractor_option = "extract_vendor_dirs=true")
