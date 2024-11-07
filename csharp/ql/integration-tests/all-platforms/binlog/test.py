import commands


def test(codeql, csharp):
    commands.run(["dotnet", "build", "test.sln", "/bl:test.binlog"])
    codeql.database.create(build_mode="none", extractor_option="binlog=test.binlog")
