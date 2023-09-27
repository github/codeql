#!/usr/bin/env python3

import sys
import glob
from pathlib import Path
import json
import subprocess
from collections import defaultdict
import yaml
import shutil
import os

VERSION = "process-mrva-results 0.0.1"

mad_path = Path(__file__).parent.parent.parent.parent / "lib/semmle/python/frameworks/data/internal/"

assert mad_path.exists(), mad_path

package_data = defaultdict(set)

# process data

class CodeQL:
    def __init__(self):
        pass

    def __enter__(self):
        self.proc = subprocess.Popen(['codeql', 'execute','cli-server'],
                      executable=shutil.which('codeql'),
                      stdin=subprocess.PIPE,
                      stdout=subprocess.PIPE,
                      stderr=sys.stderr,
                      env=os.environ.copy(),
                     )
        return self
    def __exit__(self, type, value, tb):
        self.proc.stdin.write(b'["shutdown"]\0')
        self.proc.stdin.close()
        try:
            self.proc.wait(5)
        except:
            self.proc.kill()

    def command(self, args):
        data = json.dumps(args)
        data_bytes = data.encode('utf-8')
        self.proc.stdin.write(data_bytes)
        self.proc.stdin.write(b'\0')
        self.proc.stdin.flush()
        res = b''
        while True:
           b = self.proc.stdout.read(1)
           if b == b'\0':
               return res.decode('utf-8')
           res += b

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
    with CodeQL() as codeql:
        for f in glob.glob(f"{sys.argv[1]}/**/results.bqrs", recursive=True):
            print(f"Processing {f}")

            json_data = codeql.command(["bqrs", "decode", "--format=json", f])
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
