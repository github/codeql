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
    subprocess_run(["touch", database + "/src/tmp/empty/empty" + extension])
    subprocess_run(["codeql", "database", "finalize",
                   database, "--no-pre-finalize"])


def run_codeql_query(query, database, output):
    """Runs a codeql query on the given database."""
    subprocess_run(["codeql", "query", "run", query,
                   "--database", database, "--output", output + ".bqrs"])
    subprocess_run(["codeql", "bqrs", "decode", output + ".bqrs",
                   "--format=csv", "--no-titles", "--output", output])


def append_csv_number(list, value):
    """Adds a number to the list or None if the value is not greater than 0."""
    if value > 0:
        list.append(value)
    else:
        list.append(None)


def append_csv_dict_item(list, dictionary, key):
    """Adds a dictionary item to the list if the key is in the dictionary."""
    if key in dictionary:
        list.append(dictionary[key])
    else:
        list.append(None)


def collect_package_stats(packages, filter):
    """Collects coverage statistics for packages matching the given filter."""
    sources = 0
    steps = 0
    sinks = 0
    framework_cwes = {}
    processed_packages = set()

    for package in packages:
        if filter(package):
            processed_packages.add(package)
            sources += int(packages[package]["kind"].get("source:remote", 0))
            steps += int(packages[package]["part"].get("summary", 0))
            sinks += int(packages[package]["part"].get("sink", 0))

            for cwe in cwes:
                sink = "sink:" + cwes[cwe]["sink"]
                if sink in packages[package]["kind"]:
                    if cwe not in framework_cwes:
                        framework_cwes[cwe] = 0
                    framework_cwes[cwe] += int(
                        packages[package]["kind"][sink])

    return sources, steps, sinks, framework_cwes, processed_packages


def add_package_stats_to_row(row, sorted_cwes, collect):
    """ Adds collected statistic to the row. """
    sources, steps, sinks, framework_cwes, processed_packages = collect()

    append_csv_number(row, sources)
    append_csv_number(row, steps)
    append_csv_number(row, sinks)

    for cwe in sorted_cwes:
        append_csv_dict_item(row, framework_cwes, cwe)

    return row, processed_packages


class LanguageConfig:
    def __init__(self, lang, capitalized_lang, ext, ql_path):
        self.lang = lang
        self.capitalized_lang = capitalized_lang
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
        "java", "Java", ".java", prefix + "java/ql/src/meta/frameworks/Coverage.ql")
]

with open("flow-model-coverage.rst", 'w') as rst_file:
    for config in configs:
        lang = config.lang
        db = "empty-" + lang
        ql_output = "output-" + lang + ".csv"
        create_empty_database(lang, config.ext, db)
        run_codeql_query(config.ql_path, db, ql_output)

        packages = {}
        parts = set()
        kinds = set()

        # Read the generated CSV file, and collect package statistics.
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

        # Write the denormalized package statistics to a CSV file.
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
                    append_csv_dict_item(row, packages[package]["part"], part)
                for kind in kinds:
                    append_csv_dict_item(row, packages[package]["kind"], kind)
                csvwriter.writerow(row)

        # Read the additional framework data, such as URL, friendly name
        frameworks = {}

        with open(prefix + "misc/scripts/frameworks-" + lang + ".csv") as csvfile:
            reader = csv.reader(csvfile)
            next(reader)
            for row in reader:
                framwork = row[0]
                if framwork not in frameworks:
                    frameworks[framwork] = {
                        "package": row[2],
                        "url": row[1]
                    }

        # Read the additional CWE data
        cwes = {}

        with open(prefix + "misc/scripts/cwe-sink-" + lang + ".csv") as csvfile:
            reader = csv.reader(csvfile)
            next(reader)
            for row in reader:
                cwe = row[0]
                if cwe not in cwes:
                    cwes[cwe] = {
                        "sink": row[1],
                        "label": row[2]
                    }

        file_name = "rst-csv-flow-model-coverage-" + lang + ".csv"

        rst_file.write(
            config.capitalized_lang + " framework & library support\n")
        rst_file.write("================================\n\n")
        rst_file.write(".. csv-table:: \n")
        rst_file.write("     :file: " + file_name + "\n")
        rst_file.write("     :header-rows: 1\n")
        rst_file.write("     :class: fullWidthTable\n")
        rst_file.write("     :widths: auto\n\n")

        # Write CSV file with package statistics and framework data to be used in RST file.
        with open(file_name, 'w', newline='') as csvfile:
            csvwriter = csv.writer(csvfile)

            columns = ["Framework / library", "package",
                       "remote flow sources", "taint & value steps", "sinks (total)"]
            for cwe in sorted(cwes):
                columns.append("`" + cwe + "` :sub:`" +
                               cwes[cwe]["label"] + "`")
            csvwriter.writerow(columns)

            processed_packages = set()

            for framework in sorted(frameworks):
                row = []
                # Add the framework name to the row
                if not frameworks[framework]["url"]:
                    row.append(framework)
                else:
                    row.append(
                        "`" + framework + " <" + frameworks[framework]["url"] + ">`_")

                # Add the package name to the row
                row.append(frameworks[framework]["package"])

                prefix = frameworks[framework]["package"]

                # Collect statistics on the current framework
                def collect_framework(): return collect_package_stats(
                    packages,
                    lambda p: (prefix.endswith("*") and p.startswith(prefix[:-1])) or (not prefix.endswith("*") and prefix == p))

                row, f_processed_packages = add_package_stats_to_row(
                    row, sorted(cwes), collect_framework)

                csvwriter.writerow(row)
                processed_packages.update(f_processed_packages)

            # Collect statistics on all packages that are not part of a framework
            row = ["Others", None]

            def collect_others(): return collect_package_stats(
                packages,
                lambda p: p not in processed_packages)

            row, other_packages = add_package_stats_to_row(
                row, sorted(cwes), collect_others)

            row[1] = ", ".join(sorted(other_packages))

            csvwriter.writerow(row)

            # Collect statistics on all packages
            row = ["Total", None]

            def collect_total(): return collect_package_stats(
                packages,
                lambda p: True)

            row, _ = add_package_stats_to_row(
                row, sorted(cwes), collect_total)

            csvwriter.writerow(row)
