import runs_on


@runs_on.posix
def test_implicit_build_then_run(codeql, csharp):
    codeql.database.create(command="dotnet test")


@runs_on.posix
def test_explicit_build_then_run(codeql, csharp):
    codeql.database.create(command=["dotnet build -o myout", "dotnet test myout/dotnet_test.dll"])


# Explicit build and then run tests using the absolute path.
@runs_on.posix
def test_explicit_build_then_run_abs_path(codeql, csharp, cwd):
    codeql.database.create(
        command=["dotnet build -o myout", f"dotnet test {cwd}/myout/dotnet_test.dll"]
    )
