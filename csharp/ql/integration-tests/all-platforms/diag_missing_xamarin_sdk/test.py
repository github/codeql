import dotnet

@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    codeql.database.create(_assert_failure=True)
