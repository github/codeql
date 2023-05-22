import os
from create_database_utils import *
from diagnostics_test_utils import *

# Ensure we're using an old Java version that won't work with Gradle
if "JAVA_HOME_8_X64" in os.environ:
  os.environ["JAVA_HOME"] = os.environ["JAVA_HOME_8_X64"]
  sep = ";" if platform.system() == "Windows" else ":"
  os.environ["PATH"] = "".join([os.path.join(os.environ["JAVA_HOME"], "bin"), sep, os.environ["PATH"]])

# Ensure the autobuilder *doesn't* see Java 11 or 17, which it could switch to in order to build the project:
for k in ["JAVA_HOME_11_X64", "JAVA_HOME_17_X64"]:
  if k in os.environ:
    del os.environ[k]

# Use a custom, empty toolchains.xml file so the autobuilder doesn't see any Java versions that may be
# in a system-level toolchains file
toolchains_path = os.path.join(os.getcwd(), 'toolchains.xml')

run_codeql_database_create([], lang="java", runFunction = runUnsuccessfully, db = None, extra_env={
  'LGTM_INDEX_MAVEN_TOOLCHAINS_FILE': toolchains_path
})

check_diagnostics()
