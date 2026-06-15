def test(codeql, java, check_diagnostics_java):
    codeql.database.create(_env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true"})
