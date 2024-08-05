import os
import runs_on
import pytest


@pytest.mark.resolve_build_environment(source_root="work")
@runs_on.linux
def test(codeql, go):
    os.environ["LGTM_INDEX_IMPORT_PATH"] = "glidetest"
    codeql.database.create(source_root="work")
