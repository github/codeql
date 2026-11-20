def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), "The C# tracer did not interpret the 'dotnet run' command correctly"


# option passed into `dotnet run`
def test_option(codeql, csharp):
    s = codeql.database.create(
        command=["dotnet build", "dotnet run --no-build hello world"], _capture="stdout"
    )
    check_build_out("hello, world", s)
