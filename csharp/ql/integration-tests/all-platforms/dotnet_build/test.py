import os
import pytest

def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), f"The C# tracer did not interpret the dotnet path-to-application command correctly."

@pytest.mark.parametrize("command", ["build", "msbuild -restore", "publish", "pack"])
def test1(codeql, csharp, command):
    codeql.database.create(
        command=f"dotnet {command} -t:Build,CheckMSBuildServer",
    )


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
