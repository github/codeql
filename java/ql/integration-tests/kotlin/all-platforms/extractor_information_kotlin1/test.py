def test(codeql, java_full):
    codeql.database.create(command="kotlinc -J-Xmx2G -language-version 2.0 SomeClass.kt")
