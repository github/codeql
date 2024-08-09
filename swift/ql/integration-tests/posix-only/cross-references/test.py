import runs_on
import pytest


@runs_on.posix
@pytest.mark.ql_test("DB-CHECK", xfail=True)
def test(codeql, swift):
    codeql.database.create(command="swift build")
