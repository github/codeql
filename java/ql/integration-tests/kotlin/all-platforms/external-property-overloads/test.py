import commands


def test(codeql, java_full, kotlinc_2_3_20):
    commands.run(f"{kotlinc_2_3_20} -language-version 1.9 test.kt -d lib")
    codeql.database.create(command=f"{kotlinc_2_3_20} -language-version 1.9 user.kt -cp lib")
