from create_database_utils import *

run_codeql_database_create(["kotlinc test1.kt", "kotlinc test2.kt -module-name mymodule", "kotlinc test3.kt -module-name reservedchars\\\"${}/", "javac User.java -cp ." ], lang="java")
