def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), "The C# tracer did not interpret the 'dotnet run' command correctly"

# no arguments
def test_no_args(codeql, csharp):
    s = codeql.database.create(command="dotnet run", _capture="stdout")
    check_build_out("Default reply", s)


# no arguments, but `--`
def test_no_arg_dash_dash(codeql, csharp):
    s = codeql.database.create(command="dotnet run --", _capture="stdout")
    check_build_out("Default reply", s)


# one argument, no `--`
def test_one_arg_no_dash_dash(codeql, csharp):
    s = codeql.database.create(command="dotnet run hello", _capture="stdout")
    check_build_out("Default reply", s)


# one argument, but `--`
def test_one_arg_dash_dash(codeql, csharp):
    s = codeql.database.create(command="dotnet run -- hello", _capture="stdout")
    check_build_out("Default reply", s)


# two arguments, no `--`
def test_two_args_no_dash_dash(codeql, csharp):
    s = codeql.database.create(command="dotnet run hello world", _capture="stdout")
    check_build_out("hello, world", s)


# two arguments, and `--`
def test_two_args_dash_dash(codeql, csharp):
    s = codeql.database.create(command="dotnet run -- hello world", _capture="stdout")
    check_build_out("hello, world", s)


# shared compilation enabled; tracer should override by changing the command
# to `dotnet run -p:UseSharedCompilation=true -p:UseSharedCompilation=false -- hello world`
def test_shared_compilation(codeql, csharp):
    s = codeql.database.create(
        command="dotnet run -p:UseSharedCompilation=true -- hello world", _capture="stdout"
    )
    check_build_out("hello, world", s)


# option passed into `dotnet run`
def test_option(codeql, csharp):
    s = codeql.database.create(
        command=["dotnet build", "dotnet run --no-build hello world"], _capture="stdout"
    )
    check_build_out("hello, world", s)


# two arguments, no '--' (first argument quoted)
def test_two_args_no_dash_dash_quote_first(codeql, csharp):
    s = codeql.database.create(command='dotnet run "hello world" part2', _capture="stdout")
    check_build_out("hello world, part2", s)


# two arguments, no '--' (second argument quoted) and using dotnet to execute dotnet
def test_two_args_no_dash_dash_quote_second(codeql, csharp):
    s = codeql.database.create(command='dotnet dotnet run hello "world part2"', _capture="stdout")
    check_build_out("hello, world part2", s)
