import pytest
import dotnet

@dotnet.xdist_group_if_macos
@pytest.mark.ql_test("DB-CHECK", xfail=True)
def test(codeql, csharp):
    codeql.database.create(build_mode="none")
