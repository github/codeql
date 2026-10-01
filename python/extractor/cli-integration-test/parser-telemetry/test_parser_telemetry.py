import glob
import json
import os
import sys


database = sys.argv[1]
diagnostics = []
diagnostic_dir = os.path.join(database, "diagnostic", "extractors", "python")
for path in glob.glob(os.path.join(diagnostic_dir, "*.jsonl")):
    with open(path) as diagnostic_file:
        diagnostics.extend(json.loads(line) for line in diagnostic_file)
parser_statistics = [
    diagnostic
    for diagnostic in diagnostics
    if diagnostic["source"]["id"] == "py/extractor/parser-statistics"
]
actual = (
    sum(diagnostic["attributes"]["old_parser_file_count"] for diagnostic in parser_statistics),
    sum(
        diagnostic["attributes"]["tree_sitter_parser_file_count"]
        for diagnostic in parser_statistics
    ),
)
assert actual == (1, 1), actual
