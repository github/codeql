def test(codeql, java):
    codeql.database.create(_assert_failure=True)
