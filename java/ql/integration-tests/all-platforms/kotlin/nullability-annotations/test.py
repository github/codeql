from create_database_utils import *
import os

os.mkdir('out')
os.mkdir('out2')
os.mkdir('out3')
run_codeql_database_create(["javac AnnotatedInterface.java AnnotatedMethods.java zpkg/A.java org/jetbrains/annotations/NotNull.java org/jetbrains/annotations/Nullable.java -d out", "kotlinc ktUser.kt -cp out -d out2", "javac JavaUser.java -cp out" + os.pathsep + "out2 -d out3"], lang="java")
