import dotnet

@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    codeql.database.create()
