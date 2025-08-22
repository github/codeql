import commands


def test(codeql, csharp):
    commands.run(["dotnet", "build", "a/test.csproj", "/bl:a.binlog"])
    commands.run(["dotnet", "build", "b/test.csproj", "/bl:b.binlog"])
    codeql.database.create(build_mode="none", extractor_option=["binlog=a.binlog", "binlog=b.binlog"])
