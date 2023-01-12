from create_database_utils import *

os.mkdir('bin')
run_codeql_database_create(["kotlinc test.kt -d bin", "kotlinc user.kt -cp bin", "javac User.java -cp bin"], lang="java")
