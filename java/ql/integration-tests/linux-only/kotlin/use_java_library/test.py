from create_database_utils import *
import glob

os.mkdir('build')
javaccmd = " ".join(["javac"] + glob.glob("javasrc/extlib/*.java") + ["-d", "build"])
jarcmd = " ".join(["jar", "-c", "-f", "extlib.jar", "-C", "build", "extlib"])
run_codeql_database_create([javaccmd, jarcmd, "kotlinc user.kt -cp extlib.jar"], lang="java")

