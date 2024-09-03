def test(codeql, csharp):
    codeql.database.create(_assert_failure=True)
