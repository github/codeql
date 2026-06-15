import os


def test(codeql, java_full):
    codeql.database.create(
        command=[
            "javac AnnotatedInterface.java AnnotatedMethods.java zpkg/A.java org/jetbrains/annotations/NotNull.java org/jetbrains/annotations/Nullable.java -d out",
            "kotlinc ktUser.kt -cp out -d out2",
            "javac JavaUser.java -cp out" + os.pathsep + "out2 -d out3",
        ],
    )
