def test(codeql, java_full, kotlinc_2_3_20):
    codeql.database.create(command=f"kotlinc -J-Xmx2G -language-version 1.9 SomeClass.kt")
