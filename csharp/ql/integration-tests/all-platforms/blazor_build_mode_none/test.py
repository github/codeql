import pytest

@pytest.mark.ql_test("DB-CHECK", xfail=True)
def test(codeql, csharp):
    codeql.database.create(build_mode="none")
