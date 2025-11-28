import os
import dotnet

@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_EXTRACT_WEB_VIEWS"] = "false"
    codeql.database.create(build_mode="none")
