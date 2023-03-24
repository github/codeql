from create_database_utils import *
import glob

# Compile Java untraced. Note the Java source is hidden under `javasrc` so the Kotlin compiler 
# will certainly reference the jar, not the source or class file for extlib.Lib

os.mkdir('build')
runSuccessfully(["javac"] + glob.glob("libsrc/extlib/*.java") + ["-d", "build"])
runSuccessfully(["jar", "cf", "extlib.jar", "-C", "build", "extlib"])
run_codeql_database_create(["kotlinc test.kt -cp extlib.jar"], lang="java")
