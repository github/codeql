import csv
import sys
import os
import shutil
import settings
import utils

"""
This script runs the CSV coverage report QL query, and transforms it to a more readable format.
There are two main outputs: (i) a CSV file containing the coverage data, and (ii) an RST page containing the coverage
data.
 """


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


def increment_dict_item(value, dictionary, key):
    """Increments the value of the dictionary[key] by value."""
    if key not in dictionary:
        dictionary[key] = 0
    dictionary[key] += int(value)


def collect_package_stats(packages, cwes, filter):
    """
    Collects coverage statistics for packages matching the given filter. `filter` is a `lambda` that for example (i) matches
    packages to frameworks, or (2) matches packages that were previously not processed.

    The returned statistics are used to generate a single row in a CSV file.
    """
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
    """
    Adds collected statistic to the row. `collect` is a `lambda` that returns the statistics for example for (i) individual
    frameworks, (ii) leftout frameworks summarized in the 'Others' row, or (iii) all frameworks summarized in the 'Totals'
    row.
    """
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
    utils.subprocess_run(["codeql", "--version"])
except Exception as e:
    print("Error: couldn't invoke CodeQL CLI 'codeql'. Is it on the path? Aborting.", file=sys.stderr)
    raise e

# The script can be run in two modes:
# (i) dev: run on the local developer machine, and collect the coverage data. The output is generated into the expected
#          folders: {language}/documentation/library-coverage/
# (ii) ci: run in a CI action. The output is generated to the root folder, and then in a subsequent step packaged as a
#          build artifact.
mode = "dev"
if len(sys.argv) > 1:
    mode = sys.argv[1]

if mode != "dev" and mode != "ci":
    print("Unknown execution mode: " + mode +
          ". Expected either 'dev' or 'ci'.", file=sys.stderr)
    exit(1)

# The QL model holding the CSV info can come from directly a PR or the main branch, but optionally we can use an earlier
# SHA too, therefore it's checked out seperately into a dedicated subfolder.
query_prefix = ""
if len(sys.argv) > 2:
    query_prefix = sys.argv[2] + "/"


# Languages for which we want to generate coverage reports.
configs = [
    LanguageConfig(
        "java", "Java", ".java", query_prefix + "java/ql/src/meta/frameworks/Coverage.ql")
]

# The names of input and output files. The placeholder {language} is replaced with the language name.
output_ql_csv = "output-{language}.csv"
input_framework_csv = settings.documentation_folder + "frameworks.csv"
input_cwe_sink_csv = settings.documentation_folder + "cwe-sink.csv"

if mode == "dev":
    output_rst = settings.repo_output_rst
    output_csv = settings.repo_output_csv
else:
    output_rst = settings.generated_output_rst
    output_csv = settings.generated_output_csv

for config in configs:
    lang = config.lang
    db = "empty-" + lang
    ql_output = output_ql_csv.format(language=lang)
    utils.create_empty_database(lang, config.ext, db)
    utils.run_codeql_query(config.ql_path, db, ql_output)
    shutil.rmtree(db)

    packages = {}
    parts = set()
    kinds = set()

    # Read the generated CSV file, and collect package statistics.
    with open(ql_output) as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            # row: "android.util",1,"remote","source",16
            package = row[0]
            if package not in packages:
                packages[package] = {
                    "count": row[1],
                    # part: "summary", "sink", or "source"
                    "part": {},
                    # kind: "source:remote", "sink:create-file", ...
                    "kind": {}
                }

            part = row[3]
            parts.add(part)
            increment_dict_item(row[4], packages[package]["part"], part)

            kind = part + ":" + row[2]
            kinds.add(kind)
            increment_dict_item(row[4], packages[package]["kind"], kind)

    os.remove(ql_output)

    parts = sorted(parts)
    kinds = sorted(kinds)

    # Write the denormalized package statistics to a CSV file.
    with open(output_csv.format(language=lang), 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)

        headers = ["package"]
        headers.extend(parts)
        headers.extend(kinds)

        csvwriter.writerow(headers)

        for package in sorted(packages):
            row = [package]
            for part in parts:
                append_csv_dict_item(row, packages[package]["part"], part)
            for kind in kinds:
                append_csv_dict_item(row, packages[package]["kind"], kind)
            csvwriter.writerow(row)

    # Read the additional framework data, such as URL, friendly name
    frameworks = {}

    with open(input_framework_csv.format(language=lang)) as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        for row in reader:
            # row: Hibernate,https://hibernate.org/,org.hibernate
            framwork = row[0]
            if framwork not in frameworks:
                frameworks[framwork] = {
                    "package": row[2],
                    "url": row[1]
                }

    # Read the additional CWE data
    cwes = {}

    with open(input_cwe_sink_csv.format(language=lang)) as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        for row in reader:
            # row: CWE-89,sql,SQL injection
            cwe = row[0]
            if cwe not in cwes:
                cwes[cwe] = {
                    "sink": row[1],
                    "label": row[2]
                }

    sorted_cwes = sorted(cwes)

    with open(output_rst.format(language=lang), 'w', newline='') as rst_file:
        rst_file.write(
            config.capitalized_lang + " framework & library support\n")
        rst_file.write("================================\n\n")
        rst_file.write(".. csv-table::\n")
        rst_file.write("   :header-rows: 1\n")
        rst_file.write("   :class: fullWidthTable\n")
        rst_file.write("   :widths: auto\n\n")

        row_prefix = "   "

        # Write CSV file with package statistics and framework data to be used in RST file.
        csvwriter = csv.writer(rst_file)

        # Write CSV header.
        headers = [row_prefix + "Framework / library",
                   "Package",
                   "Remote flow sources",
                   "Taint & value steps",
                   "Sinks (total)"]
        for cwe in sorted_cwes:
            headers.append(
                "`{0}` :sub:`{1}`".format(cwe, cwes[cwe]["label"]))
        csvwriter.writerow(headers)

        processed_packages = set()

        all_package_patterns = set(
            (frameworks[fr]["package"] for fr in frameworks))

        # Write a row for each framework.
        for framework in sorted(frameworks):
            row = []

            # Add the framework name to the row
            if not frameworks[framework]["url"]:
                row.append(row_prefix + framework)
            else:
                row.append(
                    row_prefix + "`" + framework + " <" + frameworks[framework]["url"] + ">`_")

            # Add the package name to the row
            row.append("``" + frameworks[framework]["package"] + "``")

            current_package_pattern = frameworks[framework]["package"]

            # Collect statistics on the current framework
            # current_package_pattern is either full name, such as "org.hibernate", or a prefix, such as "java.*"
            # Package patterns might overlap, in case of 'org.apache.commons.io' and 'org.apache.*', the statistics for
            # the latter will not include the statistics for the former.
            def package_match(package_name, pattern): return (pattern.endswith(
                "*") and package_name.startswith(pattern[:-1])) or (not pattern.endswith("*") and pattern == package_name)

            def collect_framework(): return collect_package_stats(
                packages, cwes, lambda p: package_match(p, current_package_pattern) and all(len(current_package_pattern) >= len(pattern) or not package_match(p, pattern) for pattern in all_package_patterns))

            row, f_processed_packages = add_package_stats_to_row(
                row, sorted_cwes, collect_framework)

            csvwriter.writerow(row)
            processed_packages.update(f_processed_packages)

        # Collect statistics on all packages that are not part of a framework
        row = [row_prefix + "Others", None]

        def collect_others(): return collect_package_stats(
            packages, cwes, lambda p: p not in processed_packages)

        row, other_packages = add_package_stats_to_row(
            row, sorted_cwes, collect_others)

        row[1] = ", ".join("``{0}``".format(p)
                           for p in sorted(other_packages))

        csvwriter.writerow(row)

        # Collect statistics on all packages
        row = [row_prefix + "Totals", None]

        def collect_total(): return collect_package_stats(packages, cwes, lambda p: True)

        row, _ = add_package_stats_to_row(
            row, sorted_cwes, collect_total)

        csvwriter.writerow(row)

        rst_file.write("\n")
