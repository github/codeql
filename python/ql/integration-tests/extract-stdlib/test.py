import pytest


@pytest.mark.ql_test(expected=".without-stdlib.expected")
def test_without_stdlib(codeql, python):
    codeql.database.create(source_root="repo_dir")


@pytest.mark.ql_test(expected=".with-stdlib.expected")
def test_with_stdlib(codeql, python):
    codeql.database.create(
        source_root="repo_dir",
        _env={
            "LGTM_INDEX_EXCLUDE": "/usr/lib/**",
            "CODEQL_EXTRACTOR_PYTHON_EXTRACT_STDLIB": "True",
        },
    )
