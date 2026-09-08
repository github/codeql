import os
import sys
import glob
import json
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "..", "..", "..", "..", "integration-tests"))
import diagnostics_test_utils

test_db = "db"
diagnostics = []
diagnostic_dir = os.path.join(test_db, "diagnostic", "extractors", "python")
for path in glob.glob(os.path.join(diagnostic_dir, "*.jsonl")):
    with open(path) as diagnostic_file:
        diagnostics.extend(json.loads(line) for line in diagnostic_file)
summary = [
    diagnostic
    for diagnostic in diagnostics
    if diagnostic["source"]["id"] == "py/extractor/summary"
]
assert len(summary) == 1
assert summary[0]["attributes"]["extractor_flags"] == "default"
diagnostics_test_utils.check_diagnostics(
    ".",
    test_db,
    skip_attributes=True,
    replacements={
        r'"py/extractor/parser-statistics"': '"cli/py/extractor/parser-statistics"'
    },
)
