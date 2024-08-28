import os


def test(codeql, go):
    os.environ["LGTM_INDEX_IMPORT_PATH"] = "test"
    codeql.database.create(source_root="src")
