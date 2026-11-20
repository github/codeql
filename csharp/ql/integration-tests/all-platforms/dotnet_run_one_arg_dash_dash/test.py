def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), "The C# tracer did not interpret the 'dotnet run' command correctly"


# one argument, but `--`
def test_one_arg_dash_dash(codeql, csharp):
    s = codeql.database.create(command="dotnet run -- hello", _capture="stdout")
    check_build_out("Default reply", s)
