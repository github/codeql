from create_database_utils import *

runSuccessfully([get_cmd("kotlinc"), '-language-version', '1.9', 'A.kt'])
run_codeql_database_create(['kotlinc -cp . -language-version 1.9 B.kt C.kt'], lang="java")
