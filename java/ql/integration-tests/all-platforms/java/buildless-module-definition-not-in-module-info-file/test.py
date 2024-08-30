def test(codeql, java):
    codeql.database.create(
        extractor_option="buildless=true",
    )
