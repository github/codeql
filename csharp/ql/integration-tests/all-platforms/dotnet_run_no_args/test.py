def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), "The C# tracer did not interpret the 'dotnet run' command correctly"


# no arguments
def test_no_args(codeql, csharp):
    s = codeql.database.create(command="dotnet run", _capture="stdout")
    check_build_out("Default reply", s)
