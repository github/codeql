from typing import Dict
import json
import json5
from pathlib import Path
import glob
from collections import defaultdict
import re

VERSION = "process-mrva-results 0.0.1"

mad_path = Path(__file__).parent.parent.parent.parent / "lib/semmle/python/frameworks/data/internal/"

subclass_capture_path = mad_path / "subclass-capture"

joined_file = subclass_capture_path / "ALL.model.json"

def parse_from_file(path: Path) -> set:
    if not path.exists():
        return set()

    f = path.open("r")
    assert f.readline().startswith(f"// {VERSION}\n"), path

    raw_data = json5.load(f)
    assert len(raw_data["extensions"]) == 1, path
    assert raw_data["extensions"][0]["addsTo"]["extensible"] == "typeModel", path

    return set(tuple(x) for x in raw_data["extensions"][0]["data"])


def write_data_extension(data, header_comment, path: Path):
    f = path.open("w+")
    f.write(f"// {header_comment}\n")
    # Write most of the JSON manually, for finer control over formatting
    f.write("{\n")
    f.write('  "extensions": [\n')
    f.write('    {\n')
    f.write('      "addsTo": {\n')
    f.write('        "pack": "codeql/python-all",\n')
    f.write('        "extensible": "typeModel"\n')
    f.write('      },\n')
    f.write('      "data": [\n')
    for i, row in enumerate(data):
        if i > 0:
            f.write(",\n")
        f.write(f"        {json.dumps(row)}")
    f.write('\n')
    f.write('      ]\n')
    f.write('    }\n')
    f.write("  ]\n")
    f.write("}")


def gather_from_existing():
    package_data = defaultdict(set)
    for f in glob.glob(f"{subclass_capture_path}/auto-*.model.json", recursive=True):
        print(f"Processing {f}")

        all_data = parse_from_file(Path(f))
        pkg = f.split("/")[-1].split(".")[0][5:]
        package_data[pkg].update(all_data)
    return package_data


def write_all_package_data_to_files(package_data: Dict[str, set]):
    for pkg in package_data:
        if not re.match(r"[a-zA-Z0-9-_]+", pkg):
            print(f"Skipping {repr(pkg)}")
            continue

        pkg_path = subclass_capture_path / f"auto-{pkg}.model.json"

        print(f"Writing {pkg_path}")

        all_data = parse_from_file(pkg_path)
        all_data.update(package_data[pkg])

        as_lists = [list(t) for t in all_data]
        as_lists.sort()

        write_data_extension(as_lists, VERSION, pkg_path)
