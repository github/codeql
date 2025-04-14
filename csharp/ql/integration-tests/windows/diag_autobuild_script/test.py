import runs_on


@runs_on.windows
def test(codeql, csharp):
    codeql.database.create(_assert_failure=True)
