def test(codeql, python):
    # even with default encoding that doesn't support utf-8 (like on windows) we want to
    # ensure that we can properly log that we've extracted files whose filenames contain
    # utf-8 chars
    codeql.database.create(source_root="repo_dir", _env={"PYTHONIOENCODING": "ascii"})
