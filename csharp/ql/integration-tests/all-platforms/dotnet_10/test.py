import pytest

@pytest.mark.skip(reason=".NET 10 info command crashes")
def test1(codeql, csharp):
    codeql.database.create()

@pytest.mark.skip(reason=".NET 10 info command crashes")
def test2(codeql, csharp):
    codeql.database.create(build_mode="none")
