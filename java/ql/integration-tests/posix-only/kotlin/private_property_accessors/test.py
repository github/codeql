from create_database_utils import *

run_codeql_database_create(["kotlinc hasprops.kt", "kotlinc usesprops.kt -cp ."], lang="java")
