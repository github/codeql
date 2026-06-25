def test(codeql, java_full):
    codeql.database.create(command=f"kotlinc -J-Xmx2G SomeClass.kt")
