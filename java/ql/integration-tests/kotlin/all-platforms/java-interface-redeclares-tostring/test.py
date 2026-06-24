import commands


def test(codeql, java_full, kotlinc_2_3_20):
    commands.run(["javac", "Test.java", "-d", "bin"])
    codeql.database.create(command=f"{kotlinc_2_3_20} -language-version 1.9 user.kt -cp bin")
