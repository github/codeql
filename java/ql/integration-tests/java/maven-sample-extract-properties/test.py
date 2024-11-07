def test(codeql, java):
    codeql.database.create(_env={"LGTM_INDEX_PROPERTIES_FILES": "true"})
