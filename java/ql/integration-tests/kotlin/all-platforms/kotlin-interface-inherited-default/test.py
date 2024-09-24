def test(codeql, java_full):
    codeql.database.create(
        command=[
            "kotlinc test.kt -d build",
            "kotlinc noforwards.kt -d build -Xjvm-default=all",
            "javac User.java -cp build",
        ],
    )
