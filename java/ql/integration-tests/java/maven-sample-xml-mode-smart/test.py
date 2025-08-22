def test(codeql, java):
    codeql.database.create(_env={"LGTM_INDEX_XML_MODE": "smart"})
