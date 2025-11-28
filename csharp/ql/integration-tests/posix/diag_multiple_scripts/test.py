import runs_on
import dotnet

@dotnet.xdist_group_if_macos
@runs_on.posix
def test(codeql, csharp):
    codeql.database.create(_assert_failure=True)
