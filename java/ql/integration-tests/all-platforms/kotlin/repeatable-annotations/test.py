from create_database_utils import *

os.mkdir('out')
os.mkdir('out2')
runSuccessfully([get_cmd("kotlinc"), "lib.kt", "-d", "out"])
runSuccessfully([get_cmd("javac"), "JavaDefinedContainer.java", "JavaDefinedRepeatable.java", "-d", "out"])
run_codeql_database_create(["javac JavaUser.java -cp out -d out2", "kotlinc test.kt -cp out -d out2"], lang="java")
