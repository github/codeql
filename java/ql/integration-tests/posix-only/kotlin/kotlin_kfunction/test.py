from create_database_utils import *

run_codeql_database_create(
    ["gradle build --no-daemon --no-build-cache --rerun-tasks"], lang="java")
runSuccessfully(["gradle", "clean"])
