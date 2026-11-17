def test(codeql, python, check_diagnostics):
    check_diagnostics.only_source_ids = ["py/extractor/parser-statistics"]
    codeql.database.create(source_root="repo_dir")
