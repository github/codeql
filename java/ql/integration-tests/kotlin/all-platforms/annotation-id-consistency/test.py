def test(codeql, java_full):
    codeql.database.create(
        command=["kotlinc test.kt -d out", "javac User.java -cp out -d out2", "kotlinc ktUser.kt -cp out -d out2"]
    )
