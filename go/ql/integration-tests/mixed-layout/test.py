import pytest

@pytest.mark.parametrize("build_mode", ["autobuild", "none"])
def test(codeql, go, build_mode):
    codeql.database.create(source_root="src", build_mode=build_mode)
