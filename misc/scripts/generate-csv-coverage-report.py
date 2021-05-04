import subprocess
import json
import csv
import sys
import os

"""
This script runs the CSV coverage report QL query, and transforms it to a more readable format.
"""


def subprocess_run(cmd):
    """Runs a command through subprocess.run, with a few tweaks. Raises an Exception if exit code != 0."""
    return subprocess.run(cmd, capture_output=True, text=True, env=os.environ.copy(), check=True)


def create_empty_database(lang, extension, database):
    """Creates an empty database for the given language."""
    subprocess_run(["codeql", "database", "init", "--language=" + lang,
                   "--source-root=/tmp/empty", "--allow-missing-source-root", database])
    subprocess_run(["mkdir", "-p", database + "/src/tmp/empty"])
    subprocess_run(["touch", database + "/src/tmp/empty/empty." + extension])
    subprocess_run(["codeql", "database", "finalize",
                   database, "--no-pre-finalize"])


def run_codeql_query(query, database, output):
    """Runs a codeql query on the given database."""
    subprocess_run(["codeql", "query", "run", query,
                   "--database", database, "--output", output + ".bqrs"])
    subprocess_run(["codeql", "bqrs", "decode", output + ".bqrs",
                   "--format=csv", "--no-titles", "--output", output])


class LanguageConfig:
    def __init__(self, lang, ext, ql_path):
        self.lang = lang
        self.ext = ext
        self.ql_path = ql_path


try:  # Check for `codeql` on path
    subprocess_run(["codeql", "--version"])
except Exception as e:
    print("Error: couldn't invoke CodeQL CLI 'codeql'. Is it on the path? Aborting.", file=sys.stderr)
    raise e

prefix = ""
if len(sys.argv) > 1:
    prefix = sys.argv[1] + "/"

# Languages for which we want to generate coverage reports.
configs = [
    LanguageConfig(
        "java", "java", prefix + "java/ql/src/meta/frameworks/Coverage.ql")
]

for config in configs:
    lang = config.lang
    ext = config.ext
    query_path = config.ql_path
    db = "empty-" + lang
    ql_output = "output-" + lang + ".csv"
    create_empty_database(lang, ext, db)
    run_codeql_query(query_path, db, ql_output)

    packages = {}
    parts = set()
    kinds = set()

    with open(ql_output) as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            package = row[0]
            if package not in packages:
                packages[package] = {
                    "count": row[1],
                    "part": {},
                    "kind": {}
                }
            part = row[3]
            parts.add(part)
            if part not in packages[package]["part"]:
                packages[package]["part"][part] = 0
            packages[package]["part"][part] += int(row[4])
            kind = part + ":" + row[2]
            kinds.add(kind)
            if kind not in packages[package]["kind"]:
                packages[package]["kind"][kind] = 0
            packages[package]["kind"][kind] += int(row[4])

    with open("csv-flow-model-coverage-" + lang + ".csv", 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)

        parts = sorted(parts)
        kinds = sorted(kinds)

        columns = ["package"]
        columns.extend(parts)
        columns.extend(kinds)

        csvwriter.writerow(columns)

        for package in sorted(packages):
            row = [package]
            for part in parts:
                if part in packages[package]["part"]:
                    row.append(packages[package]["part"][part])
                else:
                    row.append(None)
            for kind in kinds:
                if kind in packages[package]["kind"]:
                    row.append(packages[package]["kind"][kind])
                else:
                    row.append(None)
            csvwriter.writerow(row)
