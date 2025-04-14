import pathlib


def test_default(codeql, rust, check_source_archive):
    check_source_archive.expected_suffix = ".default.expected"
    pathlib.Path("_git").rename(".git")
    codeql.database.create()

def test_with_config(codeql, rust, check_source_archive):
    check_source_archive.expected_suffix = ".with_config.expected"
    pathlib.Path("_git").rename(".git")
    codeql.database.create(codescanning_config="codeql-config.yml")
