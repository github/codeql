def test(codeql, csharp):
    codeql.database.create(command="dotnet build")
