import os.path
import json

def test(codeql, go):
    codeql.database.init(source_root="src")
    baseline_info_path = os.path.join("test-db", "baseline-info.json")
    with open(baseline_info_path, "r") as f:
        baseline_info = json.load(f)
    assert set(baseline_info["languages"]["go"]["files"]) == set(["root.go", "c/vendor/cvendor.go"]), "Expected root.go and cvendor.go in baseline"
