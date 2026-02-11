import runs_on


@runs_on.posix
def test(codeql, csharp):
    codeql.database.create(build_mode="none")
