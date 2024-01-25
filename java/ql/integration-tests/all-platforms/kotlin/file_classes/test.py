from create_database_utils import *

runSuccessfully([get_cmd("kotlinc"), 'A.kt'])
run_codeql_database_create(['kotlinc -cp . B.kt C.kt'], lang="java")
