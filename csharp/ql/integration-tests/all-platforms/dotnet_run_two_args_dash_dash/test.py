def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), "The C# tracer did not interpret the 'dotnet run' command correctly"


# two arguments, and `--`
def test_two_args_dash_dash(codeql, csharp):
    s = codeql.database.create(command="dotnet run -- hello world", _capture="stdout")
    check_build_out("hello, world", s)
