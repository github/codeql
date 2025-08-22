import commands


def test(codeql, java_full, cwd):
    commands.run(["kotlinc", "lib.kt", "-d", "out"])
    commands.run(["javac", "JavaDefinedContainer.java", "JavaDefinedRepeatable.java", "-d", "out"])
    codeql.database.create(
        command=["kotlinc test.kt -cp out -d out", "javac JavaUser.java -cp out -d out2"]
    )
