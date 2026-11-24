import pytest


@pytest.mark.parametrize("parser", ["old", "tree-sitter"])
def test(codeql, python, check_diagnostics, parser):
    check_diagnostics.only_source_ids = ["py/extractor/parser-statistics"]
    check_diagnostics.expected_suffix = f".{parser}.expected"
    codeql.database.create(source_root=f"repo_dir/{parser}")
