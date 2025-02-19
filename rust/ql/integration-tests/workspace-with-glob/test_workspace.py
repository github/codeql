import pytest


def test_cargo(codeql, rust, check_source_archive):
    codeql.database.create()
