import commands


def test(codeql, java_full):
    commands.run("kotlinc -language-version 2.0 A.kt")
    codeql.database.create(command="kotlinc -cp . -language-version 2.0 B.kt C.kt")
