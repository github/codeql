import runs_on
import pytest


@runs_on.macos
@pytest.mark.ql_test("DB-CHECK", xfail=True)
def test(codeql, swift, xcode_16):
    codeql.database.create(
        command="xcodebuild build "
        "CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO",
    )
