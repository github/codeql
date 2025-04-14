def test(codeql, java):
    codeql.database.create(
        _env={
            "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true",
            "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true",
        }
    )
