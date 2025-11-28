import dotnet

@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    codeql.database.create(build_mode="none", _assert_failure=True)
