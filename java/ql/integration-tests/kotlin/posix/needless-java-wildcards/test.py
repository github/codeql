import runs_on


@runs_on.posix
def test(codeql, java_full):
    codeql.database.create(
        command=[
            "kotlinc kConsumer.kt -d build1",
            "javac Test.java -cp build1 -d build2",
            "kotlinc user.kt -cp build1:build2",
        ]
    )
