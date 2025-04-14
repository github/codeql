import runs_on


@runs_on.macos
def test(codeql, swift):
    codeql.database.create(command="./build.sh")
