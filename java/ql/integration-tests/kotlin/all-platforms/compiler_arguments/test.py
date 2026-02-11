def test(codeql, java_full, gradle_7_6):
    codeql.database.create(command=f"{gradle_7_6} build")
