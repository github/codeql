def test(codeql, go):
    codeql.database.create(source_root="src", _assert_failure=True)
