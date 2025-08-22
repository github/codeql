import runs_on


@runs_on.macos
def test(codeql, swift):
    codeql.database.create(_assert_failure=True)
