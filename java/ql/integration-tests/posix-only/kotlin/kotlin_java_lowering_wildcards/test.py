from create_database_utils import *

run_codeql_database_create(["kotlinc kotlindefns.kt", "javac JavaUser.java JavaDefns.java -cp .", "kotlinc -cp . kotlinuser.kt"], lang="java")
