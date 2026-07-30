def test(codeql, csharp):
    codeql.database.create(
        command=[
            "dotnet build -t:Rebuild WebApp/WebApp.csproj",
            "dotnet build -t:Rebuild Unrelated/Unrelated.csproj",
        ]
    )