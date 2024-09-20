import runs_on
import pytest


@runs_on.macos
@pytest.mark.ql_test("DB-CHECK", xfail=True)
def test(codeql, swift):
    codeql.database.create()
