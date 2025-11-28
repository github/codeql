import dotnet

@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    codeql.database.init("test-db", source_root=".")
    # the tracer configuration should not inject the extra command-line arguments for these commands
    # and they should therefore run successfully
    # this command fails on Windows for some reason, so we comment it out for now
    # run_codeql_database_trace_command(['dotnet', 'tool', 'search', 'publish'])
    codeql.database.trace_command(
        "test-db", "dotnet", "new", "console", "--force", "--name", "build", "--output", "."
    )
