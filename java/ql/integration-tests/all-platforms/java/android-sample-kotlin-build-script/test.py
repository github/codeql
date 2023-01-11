import sys

from create_database_utils import *

if "JAVA_HOME_11_X64" in os.environ:
  os.environ["JAVA_HOME"] = os.environ["JAVA_HOME_11_X64"]
  sep = ";" if platform.system() == "Windows" else ":"
  os.environ["PATH"] = "".join([os.path.join(os.environ["JAVA_HOME"], "bin"), sep, os.environ["PATH"]])

run_codeql_database_create([], lang="java")
