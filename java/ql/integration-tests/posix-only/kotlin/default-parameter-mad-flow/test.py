from create_database_utils import *
import subprocess

subprocess.check_call(["kotlinc", "lib.kt", "-d", "lib"])
run_codeql_database_create(["kotlinc user.kt -cp lib"], lang="java")
