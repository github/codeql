import os
import pytest

def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), f"The C# tracer did not interpret the dotnet path-to-application command correctly."

@pytest.mark.parametrize("command", ["build", "msbuild -restore", "publish", "pack"])
def test1(codeql, csharp, command):
    s = codeql.database.create(
        command=f"dotnet {command} -t:Build,CheckMSBuildServer -v:diag -nodeReuse:true",
        _capture="stdout",
    )
    assert any(
        "[build-stdout]" in line
        and "Command line arguments =" in line
        and "-nodeReuse:true" in line
        and "-nodeReuse:false" in line
        and line.rfind("-nodeReuse:false") > line.rfind("-nodeReuse:true")
        for line in s.splitlines()
    ), "The C# tracer did not override the explicit MSBuild node-reuse switch."


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
