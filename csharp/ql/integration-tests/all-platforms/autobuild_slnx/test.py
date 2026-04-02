def test(codeql, csharp):
    # Only proj1 is included in the solution, so only it should be built (and extracted).
    codeql.database.create()
