import runs_on


@runs_on.posix
def test(codeql, java_full):
    codeql.database.create(command=["kotlinc test.kt -d build", "javac User.java -cp build"])
