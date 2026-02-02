import runs_on
import pytest


@runs_on.macos
@pytest.mark.ql_test("DB-CHECK", xfail=not runs_on.macos_26)
@pytest.mark.ql_test("*", expected=f"{'.macos_26' if runs_on.macos_26 else ''}.expected")
def test(codeql, swift):
    codeql.database.create()
