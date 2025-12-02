import pytest

def test1(codeql, csharp):
    codeql.database.create()

def test2(codeql, csharp):
    codeql.database.create(build_mode="none")
