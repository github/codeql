from create_database_utils import *

run_codeql_database_create(["gradle build --no-daemon --no-build-cache"], lang="java")
runSuccessfully([get_cmd("gradle"), "clean"])
