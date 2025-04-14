def test(codeql, csharp):
    codeql.database.create(build_mode="none", _assert_failure=True)
