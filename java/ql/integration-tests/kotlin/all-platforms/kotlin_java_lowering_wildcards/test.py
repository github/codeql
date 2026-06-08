import commands


def test(codeql, java_full):
    # Compile the JavaDefns2 copy outside tracing, to make sure the Kotlin view of it matches the Java view seen by the traced javac compilation of JavaDefns.java below.
    commands.run(["javac", "JavaDefns2.java"])
    codeql.database.create(
        command=[
            "kotlinc kotlindefns.kt",
            "javac JavaUser.java JavaDefns.java -cp .",
            "kotlinc -language-version 2.0 -cp . kotlinuser.kt",
        ]
    )
