def test(codeql, java, gradle_7_3, android_sdk):
    codeql.database.create(_assert_failure=True)
