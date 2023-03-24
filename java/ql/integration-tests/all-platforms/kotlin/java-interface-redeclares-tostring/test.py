from create_database_utils import *

os.mkdir('bin')
runSuccessfully(["javac", "Test.java", "-d", "bin"])
run_codeql_database_create(["kotlinc user.kt -cp bin"], lang="java")
