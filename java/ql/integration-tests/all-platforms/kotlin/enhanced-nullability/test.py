from create_database_utils import *
import glob

os.mkdir('build')
runSuccessfully(["javac"] + glob.glob("*.java") + ["-d", "build"])
run_codeql_database_create(["javac " + " ".join(glob.glob("*.java")) + " -d build", "kotlinc user.kt -cp build"], lang="java")
