import pytest

@pytest.mark.ql_test(expected=".default-filters.expected")
def test_default_filters(codeql, actions, check_source_archive):
    check_source_archive.expected_suffix = ".default-filters.expected"
    codeql.database.create(source_root="src")

@pytest.mark.ql_test(expected=".paths-only.expected")
def test_config_paths_only(codeql, actions):
    codeql.database.create(source_root="src", codescanning_config="codeql-config.paths-only.yml")

@pytest.mark.ql_test(expected=".paths-ignore-only.expected")
def test_config_paths_ignore_only(codeql, actions):
    codeql.database.create(source_root="src", codescanning_config="codeql-config.paths-ignore-only.yml")

@pytest.mark.ql_test(expected=".paths-and-paths-ignore.expected")
def test_config_paths_and_paths_ignore(codeql, actions):
    codeql.database.create(source_root="src", codescanning_config="codeql-config.paths-and-paths-ignore.yml")