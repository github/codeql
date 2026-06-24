import pytest


@pytest.mark.kotlin1
def test(codeql, java_full):
    codeql.database.create(command="kotlinc -J-Xmx2G -language-version 1.9 SomeClass.kt")
