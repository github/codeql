import os
import pytest


@pytest.mark.resolve_build_environment(source_root="work")
def test(codeql, go):
    os.environ["LGTM_INDEX_IMPORT_PATH"] = "test"
    codeql.database.create(source_root="work")
