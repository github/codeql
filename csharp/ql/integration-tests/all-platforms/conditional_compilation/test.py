import os


def test(codeql, csharp):
    os.environ["CODEQL_EXTRACTOR_CSHARP_OPTION_TRAP_COMPRESSION"] = "none"
    codeql.database.create(
        command=["dotnet build /p:DefineConstants=A", "dotnet build /p:DefineConstants=B"]
    )
