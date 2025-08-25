import runs_on


@(runs_on.linux or runs_on.windows)
def test(codeql, swift):
    codeql.database.create(_assert_failure=True)
