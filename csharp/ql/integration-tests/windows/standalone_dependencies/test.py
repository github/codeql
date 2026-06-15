import runs_on


@runs_on.windows
def test(codeql, csharp):
    codeql.database.create(build_mode="none")
