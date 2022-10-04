from create_database_utils import *

os.mkdir('kbuild')
run_codeql_database_create(["kotlinc test.kt -d kbuild", "javac User.java -cp kbuild"], lang="java")
