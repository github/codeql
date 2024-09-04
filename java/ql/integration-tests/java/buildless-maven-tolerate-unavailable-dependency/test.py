def test(codeql, java):
    codeql.database.create(
        build_mode="none",
    )
