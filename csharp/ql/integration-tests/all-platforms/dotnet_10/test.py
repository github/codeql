import dotnet

@dotnet.xdist_group_if_macos
def test1(codeql, csharp):
    codeql.database.create()

@dotnet.xdist_group_if_macos
def test2(codeql, csharp):
    codeql.database.create(build_mode="none")
