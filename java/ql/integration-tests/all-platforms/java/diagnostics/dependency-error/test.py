import os
import pathlib
import shutil

from create_database_utils import *
from diagnostics_test_utils import *

# Ensure the intended dependency download failure is not cached:
try:
  shutil.rmtree(pathlib.Path.home().joinpath(".m2", "repository", "junit", "junit-nonesuch"))
except FileNotFoundError:
  pass

os.mkdir("diagnostics")
run_codeql_database_create([], lang="java", runFunction = runUnsuccessfully, db = None, extra_env = {"CODEQL_EXTRACTOR_JAVA_DIAGNOSTIC_DIR": "diagnostics"})

check_diagnostics(test_dir = ".", diagnostics_dir = "diagnostics")
