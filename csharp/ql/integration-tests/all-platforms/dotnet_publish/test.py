import os
import dotnet

@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    artifacts = "bin/Temp"
    codeql.database.create(command=f"dotnet publish -o {artifacts}")
    assert os.path.isdir(artifacts), "The publish artifact folder was not created."
