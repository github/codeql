import runs_on


@runs_on.posix
def test(codeql, java_full):
    codeql.database.create(
        command=[
            "kotlinc test1.kt",
            "kotlinc test2.kt -module-name mymodule",
            'kotlinc test3.kt -module-name reservedchars\\"${}/',
            "javac User.java -cp .",
        ]
    )
