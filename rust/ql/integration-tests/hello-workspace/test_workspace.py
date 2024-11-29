import runs_on
import pytest

@runs_on.posix
def test_cargo(codeql, rust, cargo, check_source_archive):
    codeql.database.create()

@runs_on.windows
@pytest.mark.parametrize("_", range(25))
def test_cargo_debug(codeql, rust, cargo, check_source_archive, _):
    codeql.database.create()

def test_rust_project(codeql, rust, rust_project, check_source_archive):
    codeql.database.create()
