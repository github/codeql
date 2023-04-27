from create_database_utils import *

os.mkdir('out')
os.mkdir('out2')
run_codeql_database_create(["kotlinc test.kt -d out", "javac User.java -cp out -d out2", "kotlinc ktUser.kt -cp out -d out2"], lang="java")
