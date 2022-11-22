from create_database_utils import *
import glob

# Compile library Kotlin file untraced. Note the library is hidden under `libsrc` so the Kotlin compiler 
# will certainly reference the jar, not the source or class file.

os.mkdir('build')
runSuccessfully([get_cmd("kotlinc")] + glob.glob("libsrc/*.kt") + ["-d", "build"])
runSuccessfully(["jar", "cf", "extlib.jar", "-C", "build", "abcdefghij", "-C", "build", "META-INF"])
run_codeql_database_create(["kotlinc user.kt -cp extlib.jar"], lang="java")

