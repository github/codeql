def test(codeql, use_java_11, java, gradle_7_4, android_sdk):
    codeql.database.create()
