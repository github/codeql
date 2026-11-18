import pytest


@pytest.mark.ql_test(expected=".default.expected")
def test_default(codeql, python):
    # Test 1: Default behavior should be to extract files in hidden directories
    codeql.database.create(source_root="repo_dir")


@pytest.mark.ql_test(expected=".skipped.expected")
def test_skipped(codeql, python):
    # Test 2: The default behavior can be overridden by setting `paths-ignore` in the config file
    codeql.database.create(source_root="repo_dir", codescanning_config="config.yml")
