import csv
import sys
import os
import shutil
from datetime import date
import datetime
import utils
import settings
import packages as pack
import frameworks as fr

"""
Gets the sink/source/summary statistics for different days.
"""

# the distance between commits to include in the output
day_distance = 1


class Git:
    def get_output(arr):
        r = utils.subprocess_check_output(arr)
        return r.strip("\n'")

    def get_date(sha):
        d = Git.get_output(
            ["git", "show",  "--no-patch",  "--no-notes", "--pretty='%cd'",  "--date=short", sha])
        return date.fromisoformat(d)

    def get_parent(sha):
        parent_sha = Git.get_output(
            ["git", "rev-parse",  sha + "^"])
        parent_date = Git.get_date(parent_sha)
        return (parent_sha, parent_date)

    def get_previous_sha(sha, date):
        parent_sha, parent_date = Git.get_parent(sha)
        while parent_date > date + datetime.timedelta(days=-1 * day_distance):
            parent_sha, parent_date = Git.get_parent(parent_sha)

        return (parent_sha, parent_date)


def get_packages(lang, query, search_path):
    try:
        db = "empty_" + lang
        ql_output = "output-" + lang + ".csv"
        if os.path.isdir(db):
            shutil.rmtree(db)
        utils.create_empty_database(lang, ".java", db)
        utils.run_codeql_query(query, db, ql_output, search_path)

        return pack.PackageCollection(ql_output)
    except:
        print("Unexpected error:", sys.exc_info()[0])
        raise Exception()
    finally:
        if os.path.isfile(ql_output):
            os.remove(ql_output)

        if os.path.isdir(db):
            shutil.rmtree(db)


working_dir = ""
if len(sys.argv) > 1:
    working_dir = sys.argv[1]
else:
    print("Working directory is not specified")
    exit(1)

configs = [
    utils.LanguageConfig(
        "java", "Java", ".java", "java/ql/src/meta/frameworks/Coverage.ql"),
    utils.LanguageConfig(
        "csharp", "C#", ".cs", "csharp/ql/src/meta/frameworks/Coverage.ql")
]

output_prefix = "framework-coverage-timeseries-"

languages_to_process = set()
language_utils = {}

# Try to create output files for each language:
for lang in settings.languages:
    try:
        file_total = open(output_prefix + lang + ".csv", 'w', newline='')
        file_packages = open(output_prefix + lang +
                             "-packages.csv", 'w', newline='')
        csvwriter_total = csv.writer(file_total)
        csvwriter_packages = csv.writer(file_packages)
    except:
        print(
            f"Unexpected error while opening files for {lang}:", sys.exc_info()[0])
        if file_total is not None:
            file_total.close()
        if file_packages is not None:
            file_packages.close()
    else:
        languages_to_process.add(lang)
        language_utils[lang] = {
            "file_total": file_total,
            "file_packages": file_packages,
            "csvwriter_total": csvwriter_total,
            "csvwriter_packages": csvwriter_packages
        }

try:
    # Write headers
    for lang in languages_to_process:
        csvwriter_total = language_utils[lang]["csvwriter_total"]
        csvwriter_packages = language_utils[lang]["csvwriter_packages"]
        csvwriter_total.writerow(
            ["SHA", "Date", "Sources", "Sinks", "Summaries"])
        csvwriter_packages.writerow(
            ["SHA", "Date", "Framework", "Package", "Sources", "Sinks", "Summaries"])

    os.chdir(working_dir)

    utils.subprocess_run(["git", "checkout", "main"])

    current_sha = Git.get_output(["git", "rev-parse", "HEAD"])
    current_date = Git.get_date(current_sha)

    # Read the additional framework data, such as URL, friendly name from the latest commit
    for lang in languages_to_process:
        input_framework_csv = settings.documentation_folder_no_prefix + "frameworks.csv"
        language_utils[lang]["frameworks"] = fr.FrameworkCollection(
            input_framework_csv.format(language=lang))
        language_utils[lang]["config"] = [
            c for c in configs if c.lang == lang][0]

    while True:
        utils.subprocess_run(["git", "checkout", current_sha])
        for lang in languages_to_process.copy():
            try:
                print(
                    f"Getting stats for {lang} at {current_sha} on {current_date.isoformat()}")

                config: utils.LanguageConfig = language_utils[lang]["config"]
                frameworks: fr.FrameworkCollection = language_utils[lang]["frameworks"]
                csvwriter_total = language_utils[lang]["csvwriter_total"]
                csvwriter_packages = language_utils[lang]["csvwriter_packages"]

                packages = get_packages(lang, config.ql_path, ".")

                csvwriter_total.writerow([
                    current_sha,
                    current_date,
                    packages.get_part_count("source"),
                    packages.get_part_count("sink"),
                    packages.get_part_count("summary")])

                matched_packages = set()

                # Getting stats for frameworks:
                for framework in frameworks.get_frameworks():
                    framework: fr.Framework = framework

                    row = [current_sha, current_date,
                           framework.name, framework.package_pattern]

                    sources = 0
                    sinks = 0
                    summaries = 0

                    for package in packages.get_packages():
                        if frameworks.get_package_filter(framework)(package):
                            sources += package.get_part_count("source")
                            sinks += package.get_part_count("sink")
                            summaries += package.get_part_count("summary")
                            matched_packages.add(package.name)

                    row.append(sources)
                    row.append(sinks)
                    row.append(summaries)

                    csvwriter_packages.writerow(row)

                # Getting stats for packages not included in frameworks:
                row = [current_sha, current_date, "Others"]

                sources = 0
                sinks = 0
                summaries = 0
                other_packages = set()

                for package in packages.get_packages():
                    if not package.name in matched_packages:
                        sources += package.get_part_count("source")
                        sinks += package.get_part_count("sink")
                        summaries += package.get_part_count("summary")
                        other_packages.add(package.name)

                row.append(", ".join(sorted(other_packages)))
                row.append(sources)
                row.append(sinks)
                row.append(summaries)

                csvwriter_packages.writerow(row)

                print(
                    f"Collected stats for {lang} at {current_sha} on {current_date.isoformat()}")

            except:
                print(
                    f"Error getting stats for {lang} at {current_sha}. Stopping iteration for language.")
                languages_to_process.remove(lang)
        if len(languages_to_process) == 0:
            break

        current_sha, current_date = Git.get_previous_sha(
            current_sha, current_date)

finally:
    utils.subprocess_run(["git", "checkout", "main"])

    # Close files:
    for lang in settings.languages:
        file_total = language_utils[lang]["file_total"]
        file_packages = language_utils[lang]["file_packages"]
        if file_total is not None:
            file_total.close()
        if file_packages is not None:
            file_packages.close()
