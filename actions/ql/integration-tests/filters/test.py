import pytest

@pytest.mark.ql_test(expected=".default-filters.expected")
def test_default_filters(codeql, actions, check_source_archive):
    check_source_archive.expected_suffix = ".default-filters.expected"
    codeql.database.create(source_root="src")