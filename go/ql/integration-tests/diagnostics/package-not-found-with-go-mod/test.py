import os


def test(codeql, go, check_build_environment):
    check_build_environment.source_root = "work"
    os.environ["LGTM_INDEX_IMPORT_PATH"] = "test"

    # The diagnostic message depends on the environment we are running in. To ensure consistent
    # output, we set `GITHUB_ACTIONS` to `true` if we are not actually running in a workflow.
    if (os.environ.get("GITHUB_ACTIONS", "") != "true"):
        os.environ["GITHUB_ACTIONS"] = "true"

    codeql.database.create(source_root="work")
