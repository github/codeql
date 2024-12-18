import runs_on


@runs_on.linux
def test(codeql, csharp):
    codeql.database.create()
