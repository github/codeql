import commands


def test(codeql, java_full):
    commands.run("kotlinc -language-version 1.9 test.kt -d lib")
    codeql.database.create(command="kotlinc -language-version 1.9 user.kt -cp lib")
