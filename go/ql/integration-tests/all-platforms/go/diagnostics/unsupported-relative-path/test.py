import os
import pytest


@pytest.mark.resolve_build_environment(source_root="work")
def test(codeql, go):
    os.environ["GITHUB_REPOSITORY"] = "a/b"
    codeql.database.create(source_root="work")
