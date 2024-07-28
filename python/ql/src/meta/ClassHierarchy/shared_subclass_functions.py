from typing import Dict
import yaml
from pathlib import Path
import glob
from collections import defaultdict
import re

VERSION = "process-mrva-results 0.0.1"

mad_path = Path(__file__).parent.parent.parent.parent / "lib/semmle/python/frameworks/data/internal/"

subclass_capture_path = mad_path / "subclass-capture"

joined_file = subclass_capture_path / "ALL.model.yml"

def parse_from_file(path: Path) -> set:
    if not path.exists():
        return set()

    f = path.open("r")
    assert f.readline().startswith(f"# {VERSION}\n"), path

    raw_data = yaml.load(f, Loader=yaml.CBaseLoader)
    assert len(raw_data["extensions"]) == 1, path
    assert raw_data["extensions"][0]["addsTo"]["extensible"] == "typeModel", path

    return set(tuple(x) for x in raw_data["extensions"][0]["data"])


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


def write_data(data, path: Path):
    f = path.open("w+")
    f.write(f"# {VERSION}\n")
    yaml.dump(data, indent=2, stream=f, Dumper=yaml.CDumper)


def gather_from_existing():
    package_data = defaultdict(set)
    for f in glob.glob(f"{subclass_capture_path}/auto-*.model.yml", recursive=True):
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

        pkg_path = subclass_capture_path / f"auto-{pkg}.model.yml"

        print(f"Writing {pkg_path}")

        all_data = parse_from_file(pkg_path)
        all_data.update(package_data[pkg])

        as_lists = [list(t) for t in all_data]
        as_lists.sort()

        data_for_yaml = wrap_in_template(as_lists)

        write_data(data_for_yaml, pkg_path)
