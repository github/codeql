from create_database_utils import *

os.mkdir('build1')
os.mkdir('build2')
run_codeql_database_create(["kotlinc kConsumer.kt -d build1", "javac Test.java -cp build1 -d build2", "kotlinc user.kt -cp build1:build2"], lang="java")
