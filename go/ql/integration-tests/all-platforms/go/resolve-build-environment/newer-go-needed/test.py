import pytest


@pytest.mark.resolve_build_environment(env={"GOTOOLCHAIN": "go1.21.0"})
def test(codeql, go):
    codeql.database.create(source_root="src")
