import runs_on


@runs_on.posix
def test(codeql, swift):
    codeql.database.create(command="swift build")
