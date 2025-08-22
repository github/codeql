import os
import runs_on


@runs_on.posix
def test(codeql, csharp):
    os.environ["PROJECT_TO_BUILD"] = "proj.csproj.no_auto"
    codeql.database.create()
