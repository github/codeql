import commands


def test(codeql, java_full):
    commands.run(["javac", "Test.java", "-d", "bin"])
    codeql.database.create(command="kotlinc -language-version 2.0 user.kt -cp bin")
