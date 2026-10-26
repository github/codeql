import os


def test(codeql, csharp):
    artifacts = "bin/Temp"
    codeql.database.create(command=f"dotnet publish -o {artifacts}")
    assert os.path.isdir(artifacts), "The publish artifact folder was not created."
