import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "..", "..", "..", "..", "integration-tests"))
import diagnostics_test_utils

test_db = "db"
diagnostics_test_utils.check_diagnostics(".", test_db, skip_attributes=True)
