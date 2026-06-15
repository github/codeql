import os


def test(codeql, go, check_build_environment):
    check_build_environment.source_root = "work"
    os.environ["GITHUB_REPOSITORY"] = "a/b"
    codeql.database.create(source_root="work")
