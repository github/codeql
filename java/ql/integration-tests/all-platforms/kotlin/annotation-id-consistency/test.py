import os


def test(codeql, java_full):
    os.mkdir("out")
    codeql.database.create(
        command=["kotlinc test.kt -d out", "javac User.java -cp out", "kotlinc ktUser.kt -cp out"]
    )
