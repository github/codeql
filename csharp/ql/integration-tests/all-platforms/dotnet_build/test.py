def check_build_out(msg, s):
    assert (
        "[build-stdout] " + msg in s
    ), f"The C# tracer did not interpret the dotnet path-to-application command correctly."


def test1(codeql, csharp):
    codeql.database.create(command="dotnet build")


# This test checks that we don't inject any flags when running the application using `dotnet`
def test2(codeql, csharp, cwd):
    s = codeql.database.create(
        command=[
            "dotnet build -o my_program",
            f"dotnet {cwd / 'my_program'}/dotnet_build.dll build is not a subcommand",
        ],
        _capture="stdout",
    )

    check_build_out("<arguments>build,is,not,a,subcommand</arguments>", s)
