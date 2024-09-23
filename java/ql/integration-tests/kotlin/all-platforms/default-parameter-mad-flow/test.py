import commands


def test(codeql, java_full):
    commands.run("kotlinc lib.kt -d lib")
    codeql.database.create(command=["kotlinc user.kt -cp lib"])
