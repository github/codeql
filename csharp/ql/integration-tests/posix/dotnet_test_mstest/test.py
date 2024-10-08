import runs_on


@runs_on.posix
def test_implicit_build_and_test(codeql, csharp):
    codeql.database.create(command="dotnet test")


# Explicitly build and then run tests.
@runs_on.posix
def test_explicit_build_and_test(codeql, csharp):
    # Fix `dotnet test` picking `x64` on arm-based macOS
    architecture = "-a arm64" if runs_on.arm64 else ""
    codeql.database.create(
        command=[
            "dotnet build -o myout --os win",
            f"dotnet test myout/dotnet_test_mstest.exe {architecture}",
        ]
    )
