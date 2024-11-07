def test(codeql, javascript):
    codeql.database.create(extractor_option="skip_types=true")
