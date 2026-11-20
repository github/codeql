def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), "The C# tracer did not interpret the 'dotnet run' command correctly"


# two arguments, no '--' (second argument quoted) and using dotnet to execute dotnet
def test_two_args_no_dash_dash_quote_second(codeql, csharp):
    s = codeql.database.create(command='dotnet dotnet run hello "world part2"', _capture="stdout")
    check_build_out("hello, world part2", s)
