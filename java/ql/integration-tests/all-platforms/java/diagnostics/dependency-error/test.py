import os
import pathlib
import shutil
import re

from create_database_utils import *
from diagnostics_test_utils import *

# Ensure the intended dependency download failure is not cached:
try:
  shutil.rmtree(pathlib.Path.home().joinpath(".m2", "repository", "junit", "junit-nonesuch"))
except FileNotFoundError:
  pass

run_codeql_database_create([], lang="java", runFunction = runUnsuccessfully, db = None)

# Drop the specific output line here because it varies from version to version of Maven.
check_diagnostics(replacements = {"Relevant output line: [^\"]*": ""})
