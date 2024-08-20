def test(codeql, java_full):
    codeql.database.create(
        command=[
            "kotlinc ReadsFields.java hasFields.kt -d kbuild",
            "javac ReadsFields.java -cp kbuild",
        ],
    )
