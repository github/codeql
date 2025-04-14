def test(codeql, javascript):
    codeql.database.create(_assert_failure=True)
