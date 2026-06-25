import commands


def test(codeql, java_full):
    commands.run("kotlinc A.kt")
    codeql.database.create(command="kotlinc -cp . B.kt C.kt")
