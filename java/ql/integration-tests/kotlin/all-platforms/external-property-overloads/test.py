import commands


def test(codeql, java_full):
    commands.run("kotlinc -language-version 2.0 test.kt -d lib")
    codeql.database.create(command="kotlinc -language-version 2.0 user.kt -cp lib")
