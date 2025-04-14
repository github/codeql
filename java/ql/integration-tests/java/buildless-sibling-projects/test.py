def test(codeql, use_java_11, java, actions_toolchains_file):
    # The version of gradle used doesn't work on java 17
    codeql.database.create(
        _env={
            "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true",
            "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true",
            "LGTM_INDEX_MAVEN_TOOLCHAINS_FILE": str(actions_toolchains_file),
        }
    )
