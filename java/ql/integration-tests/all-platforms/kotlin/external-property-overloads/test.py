from create_database_utils import *

os.mkdir('lib')
runSuccessfully([get_cmd("kotlinc"), "-language-version", "1.9", "test.kt", "-d", "lib"])
run_codeql_database_create(["kotlinc -language-version 1.9 user.kt -cp lib"], lang="java")
