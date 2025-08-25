def test(codeql, go, check_build_environment):
    check_build_environment.env = {"GOTOOLCHAIN": "go1.21.0"}
    codeql.database.create(source_root="src")
