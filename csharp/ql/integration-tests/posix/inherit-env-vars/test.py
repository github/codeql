import os
import runs_on
import dotnet

@dotnet.xdist_group_if_macos
@runs_on.posix
def test(codeql, csharp):
    os.environ["PROJECT_TO_BUILD"] = "proj.csproj.no_auto"
    codeql.database.create()
