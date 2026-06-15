import runs_on


@runs_on.linux
def test(codeql, swift):
    codeql.database.create(command="swiftc -enable-bare-slash-regex regex.swift -o /dev/null")
