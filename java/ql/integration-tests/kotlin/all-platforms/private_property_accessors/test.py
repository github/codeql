def test(codeql, java_full):
    codeql.database.create(command=["kotlinc hasprops.kt", "kotlinc usesprops.kt -cp ."])
