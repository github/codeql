def test(codeql, java_full):
    codeql.database.create(
        command=[
            "kotlinc FileA.kt FileB.kt",
        ],
    )
