def check_build_out(msg, s):
    lines = s.splitlines()
    assert (
        any (("[build-stdout]" in line) and (msg in line) for line in lines)
    ), "The C# tracer did not interpret the 'dotnet run' command correctly"


# shared compilation enabled; tracer should override by changing the command
# to `dotnet run -p:UseSharedCompilation=true -p:UseSharedCompilation=false -- hello world`
def test_shared_compilation(codeql, csharp):
    s = codeql.database.create(
        command="dotnet run -p:UseSharedCompilation=true -- hello world", _capture="stdout"
    )
    check_build_out("hello, world", s)
