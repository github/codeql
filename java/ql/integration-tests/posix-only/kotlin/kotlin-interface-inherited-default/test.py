from create_database_utils import *
import glob

os.mkdir('build')
run_codeql_database_create(["kotlinc test.kt -d build", "kotlinc noforwards.kt -d build -Xjvm-default=all", "javac User.java -cp build"], lang="java")

