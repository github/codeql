from create_database_utils import *

runSuccessfully(["kotlinc", "test.kt", "-d", "lib"])
run_codeql_database_create(["kotlinc user.kt -cp lib"], lang="java")
