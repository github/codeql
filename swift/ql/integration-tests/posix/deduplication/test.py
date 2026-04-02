import pytest
import runs_on


@runs_on.posix
@pytest.mark.ql_test("DB-CHECK", xfail=runs_on.linux)
def test(codeql, swift):
    codeql.database.create(command="swift build", keep_trap=True)
