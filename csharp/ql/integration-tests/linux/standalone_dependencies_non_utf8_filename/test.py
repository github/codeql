import runs_on


@runs_on.linux
def test(codeql, csharp):
    path = b"\xd2abcd.cs"

    with open(path, "w") as file:
        file.write("class X { }\n")
        codeql.database.create(build_mode="none")
