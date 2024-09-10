import os
import runs_on
import pytest


@runs_on.posix
@pytest.mark.ql_test("DB-CHECK", xfail=True)
def test(codeql, swift):
    symlinks = ["preserve/Sources/A.swift", "resolve/Sources/A.swift"]

    for s in symlinks:
        try:
            os.symlink(os.getcwd() + "/main.swift", s)
        except:
            pass
    codeql.database.create(
        command=[
            "swift build --package-path resolve",
            "env CODEQL_PRESERVE_SYMLINKS=true swift build --package-path preserve",
        ]
    )
