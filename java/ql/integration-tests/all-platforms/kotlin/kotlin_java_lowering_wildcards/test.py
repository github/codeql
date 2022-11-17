from create_database_utils import *

# Compile the JavaDefns2 copy outside tracing, to make sure the Kotlin view of it matches the Java view seen by the traced javac compilation of JavaDefns.java below.
runSuccessfully(["javac", "JavaDefns2.java"])
run_codeql_database_create(["kotlinc kotlindefns.kt", "javac JavaUser.java JavaDefns.java -cp .", "kotlinc -cp . kotlinuser.kt"], lang="java")
