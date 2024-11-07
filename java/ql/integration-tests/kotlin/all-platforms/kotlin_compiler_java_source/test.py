def test(codeql, java_full):
    # Steps:
    # 1. Compile Kotlin passing Java source code. J.class is extracted with an unknown binary location
    # 2. Compile Java producing a class file. J.class should be re-extracted this time with a known binary location
    # 3. Compile a Kotlin user passing a Java class file on the classpath. Should reference the class file location that step 1 didn't know, but step 2 did.
    codeql.database.create(
        command=[
            "kotlinc J.java K.kt -d build",
            "javac J.java -d build",
            "kotlinc K2.kt -cp build -d build",
        ]
    )
