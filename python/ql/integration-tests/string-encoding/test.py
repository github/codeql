def test(codeql, python):
    codeql.database.create(source_root="repo_dir")
    codeql.dataset.check("test-db/db-python")
