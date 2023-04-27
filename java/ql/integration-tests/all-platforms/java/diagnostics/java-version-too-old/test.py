import os
from create_database_utils import *
from diagnostics_test_utils import *

# Ensure we're using an old Java version that won't work with Gradle
if "JAVA_HOME_8_X64" in os.environ:
  os.environ["JAVA_HOME"] = os.environ["JAVA_HOME_8_X64"]
  sep = ";" if platform.system() == "Windows" else ":"
  os.environ["PATH"] = "".join([os.path.join(os.environ["JAVA_HOME"], "bin"), sep, os.environ["PATH"]])

run_codeql_database_create([], lang="java", runFunction = runUnsuccessfully, db = None)

check_diagnostics()
