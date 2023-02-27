from create_database_utils import *
from diagnostics_test_utils import *

import glob
import os.path

os.mkdir('fake-kotlinc-classes')
runSuccessfully(["javac"] + [os.path.relpath(x, "fake-kotlinc-source") for x in glob.glob("fake-kotlinc-source/**/*.java", recursive = True)] + ["-d", "../fake-kotlinc-classes"], cwd = "fake-kotlinc-source")
run_codeql_database_create(["java -cp fake-kotlinc-classes driver.Main"], lang = "java", runFunction = runUnsuccessfully, db = None)

check_diagnostics()
