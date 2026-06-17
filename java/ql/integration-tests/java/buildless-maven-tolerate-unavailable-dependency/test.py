def test(codeql, java, check_diagnostics_java):
    codeql.database.create(
        build_mode="none",
    )
