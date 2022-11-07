from create_database_utils import *

os.mkdir('build')
run_codeql_database_create(["kotlinc test.kt -d build", "javac User.java -cp build"], lang="java")
