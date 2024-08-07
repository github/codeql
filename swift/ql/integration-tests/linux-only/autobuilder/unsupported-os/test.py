import runs_on


@runs_on.linux
def test(codeql, swift):
    codeql.database.create(_assert_failure=True)
