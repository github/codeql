import subprocess
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
        r = subprocess.check_output(arr, text=True, env=os.environ.copy())
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


def get_packages(lang, query):
    try:
        db = "empty_" + lang
        ql_output = "output-" + lang + ".csv"
        if os.path.isdir(db):
            shutil.rmtree(db)
        utils.create_empty_database(lang, ".java", db)
        utils.run_codeql_query(query, db, ql_output)

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

configs = [
    utils.LanguageConfig(
        "java", "Java", ".java", "java/ql/src/meta/frameworks/Coverage.ql")
]

# todo: change this when we cover multiple languages. We should compute the SHAs
# only once and not per language
for config in configs:
    with open("timeseries-" + config.lang + ".csv", 'w', newline='') as csvfile_total:
        with open("timeseries-" + config.lang + "-packages.csv", 'w', newline='') as csvfile_packages:
            csvwriter_total = csv.writer(csvfile_total)
            csvwriter_packages = csv.writer(csvfile_packages)
            csvwriter_total.writerow(
                ["SHA", "Date", "Sources", "Sinks", "Summaries"])
            csvwriter_packages.writerow(
                ["SHA", "Date", "Framework", "Package", "Sources", "Sinks", "Summaries"])

            os.chdir(working_dir)

            utils.subprocess_run(["git", "checkout", "main"])

            current_sha = Git.get_output(["git", "rev-parse", "HEAD"])
            current_date = Git.get_date(current_sha)

            # Read the additional framework data, such as URL, friendly name from the latest commit
            input_framework_csv = settings.documentation_folder_no_prefix + "frameworks.csv"
            frameworks = fr.FrameworkCollection(
                input_framework_csv.format(language=config.lang))

            while True:
                print("Getting stats for " + current_sha)
                utils.subprocess_run(["git", "checkout", current_sha])

                try:
                    packages = get_packages(config.lang, config.ql_path)

                    csvwriter_total.writerow([
                        current_sha,
                        current_date,
                        packages.get_part_count("source"),
                        packages.get_part_count("sink"),
                        packages.get_part_count("summary")])

                    matched_packages = set()

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

                    print("Collected stats for " + current_sha +
                          " at " + current_date.isoformat())
                except:
                    print("Error getting stats for " +
                          current_sha + ". Stopping iteration.")
                    break

                current_sha, current_date = Git.get_previous_sha(
                    current_sha, current_date)

    utils.subprocess_run(["git", "checkout", "main"])
