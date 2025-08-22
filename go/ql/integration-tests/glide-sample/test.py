import os
import runs_on


@runs_on.linux
def test(codeql, go, check_build_environment):
    check_build_environment.source_root = "work"
    os.environ["LGTM_INDEX_IMPORT_PATH"] = "glidetest"
    codeql.database.create(source_root="work")
