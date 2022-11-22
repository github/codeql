from create_database_utils import *

os.mkdir('build')
run_codeql_database_create(["kotlinc ReadsFields.java hasFields.kt -d kbuild", "javac ReadsFields.java -cp kbuild"], lang="java")
