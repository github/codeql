import os
import dotnet

@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    os.environ["CODEQL_EXTRACTOR_CSHARP_OPTION_BUILDLESS"] = "true"
    codeql.database.create()
