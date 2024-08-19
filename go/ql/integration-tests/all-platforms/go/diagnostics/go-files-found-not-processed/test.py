import os


def test(codeql, go, check_build_environment):
    check_build_environment.source_root = "work"
    os.environ["LGTM_INDEX_IMPORT_PATH"] = "test"
    codeql.database.create(source_root="work")
