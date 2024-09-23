def test(codeql, java_full):
    codeql.database.create(
        command=["kotlinc test.kt -d bin", "kotlinc user.kt -cp bin", "javac User.java -cp bin"]
    )
