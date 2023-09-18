#!/usr/bin/env python3

import sys
import glob
from pathlib import Path
import json
import subprocess
from collections import defaultdict
import yaml

VERSION = "process-mrva-results 0.0.1"

mad_path = Path(__file__).parent.parent.parent.parent / "lib/semmle/python/frameworks/data/internal/"

assert mad_path.exists(), mad_path

package_data = defaultdict(set)

# process data

def wrap_in_template(data):
    return {
        "extensions": [
            {
                "addsTo": {
                    "pack": "codeql/python-all",
                    "extensible": "typeModel",
                },
                "data": data,
            }
        ]
    }

def parse_from_file(path: Path) -> set:
    if not path.exists():
        return set()

    text = path.read_text()
    assert text.startswith(f"# {VERSION}\n"), f"{path}: {text[:100]}"

    raw_data = yaml.safe_load(text)
    assert len(raw_data["extensions"]) == 1, path
    assert raw_data["extensions"][0]["addsTo"]["extensible"] == "typeModel", path

    return set(tuple(x) for x in raw_data["extensions"][0]["data"])


def gather_from_bqrs_results():
    for f in glob.glob(f"{sys.argv[1]}/**/results.bqrs", recursive=True):
        print(f"Processing {f}")

        json_data = subprocess.check_output(["codeql", "bqrs", "decode", "--format=json", f])
        select = json.loads(json_data)

        for t in select["#select"]["tuples"]:
            pkg = t[1]
            package_data[pkg].add(tuple(t))

def gather_from_existing():
    for f in glob.glob(f"{mad_path}/auto-*.model.yml", recursive=True):
        print(f"Processing {f}")

        all_data = parse_from_file(Path(f))
        pkg = f.split("/")[-1].split(".")[0][5:]
        package_data[pkg].update(all_data)

gather_from_bqrs_results()

for pkg in package_data:
    pkg_path = mad_path / f"auto-{pkg}.model.yml"

    print(f"Writing {pkg_path}")

    all_data = parse_from_file(pkg_path)
    all_data.update(package_data[pkg])

    as_lists = [list(t) for t in all_data]
    as_lists.sort()

    data_for_yaml = wrap_in_template(as_lists)

    pkg_path.write_text(f"# {VERSION}\n" + yaml.dump(data_for_yaml, indent=2))
