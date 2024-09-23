import commands


def test(codeql, java_full):
    commands.run("kotlinc -language-version 1.9 A.kt")
    codeql.database.create(command="kotlinc -cp . -language-version 1.9 B.kt C.kt")
