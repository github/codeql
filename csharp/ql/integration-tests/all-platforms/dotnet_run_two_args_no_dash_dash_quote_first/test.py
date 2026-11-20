def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), "The C# tracer did not interpret the 'dotnet run' command correctly"


# two arguments, no '--' (first argument quoted)
def test_two_args_no_dash_dash_quote_first(codeql, csharp):
    s = codeql.database.create(command='dotnet run "hello world" part2', _capture="stdout")
    check_build_out("hello world, part2", s)
