import pytest

@pytest.mark.flaky(rerun_filter=lambda *args: runs_on.macos)
def test1(codeql, csharp):
    codeql.database.create()

@pytest.mark.flaky(rerun_filter=lambda *args: runs_on.macos)
def test2(codeql, csharp):
    codeql.database.create(build_mode="none")
