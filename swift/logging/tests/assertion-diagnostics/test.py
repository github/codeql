import importlib
import os
import subprocess
# We have to use importlib due to the '-' in the path
diagnostics_test_utils = importlib.import_module("swift.ql.integration-tests.diagnostics_test_utils")

test_dir = "swift/logging/tests/assertion-diagnostics"

os.environ["CODEQL_EXTRACTOR_SWIFT_DIAGNOSTIC_DIR"] = "."
subprocess.run(os.path.join(test_dir, "assert-false"))

with open(os.path.join("test", os.listdir("test")[0]), "r") as actual:
    diagnostics_test_utils.check_diagnostics(test_dir=test_dir,
                                             # Put the diagnostic in a JSON array
                                             actual='[' + actual.read() + ']')
