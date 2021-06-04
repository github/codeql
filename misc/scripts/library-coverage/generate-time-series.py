import subprocess
import csv
import sys
import os
import shutil
from datetime import date
import datetime
import utils

"""
    Gets the sink/source/summary statistics for different days.
"""

# the distance between commits to include in the output
day_distance = 1


def get_str_output(arr):
    r = subprocess.check_output(arr)
    return r.decode("utf-8").strip("\n'")


def get_date(sha):
    d = get_str_output(
        ["git", "show",  "--no-patch",  "--no-notes", "--pretty='%cd'",  "--date=short", sha])
    return date.fromisoformat(d)


def get_parent(sha, date):
    parent_sha = get_str_output(
        ["git", "rev-parse",  sha + "^"])
    parent_date = get_date(parent_sha)
    return (parent_sha, parent_date)


def get_previous_sha(sha, date):
    parent_sha, parent_date = get_parent(sha, date)
    while parent_date > date + datetime.timedelta(days=-1 * day_distance):
        parent_sha, parent_date = get_parent(parent_sha, parent_date)

    return (parent_sha, parent_date)


def get_stats(lang, query):
    try:
        db = "empty_" + lang
        ql_output = "output-" + lang + ".csv"
        if os.path.isdir(db):
            shutil.rmtree(db)
        utils.create_empty_database(lang, ".java", db)
        utils.run_codeql_query(query, db, ql_output)

        sources = 0
        sinks = 0
        summaries = 0

        packages = {}

        with open(ql_output) as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                # row: "android.util",1,"remote","source",16
                package = row[0]
                if package not in packages:
                    packages[package] = {
                        "sources": 0,
                        "sinks": 0,
                        "summaries": 0
                    }

                if row[3] == "source":
                    sources += int(row[4])
                    packages[package]["sources"] += int(row[4])
                if row[3] == "sink":
                    sinks += int(row[4])
                    packages[package]["sinks"] += int(row[4])
                if row[3] == "summary":
                    summaries += int(row[4])
                    packages[package]["summaries"] += int(row[4])

        os.remove(ql_output)

        return (sources, sinks, summaries, packages)
    except:
        print("Unexpected error:", sys.exc_info()[0])
        raise Exception()
    finally:
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
                ["SHA", "Date", "Package", "Sources", "Sinks", "Summaries"])

            os.chdir(working_dir)

            utils.subprocess_run(["git", "checkout", "main"])

            current_sha = get_str_output(["git", "rev-parse", "HEAD"])
            current_date = get_date(current_sha)

            while True:
                print("Getting stats for " + current_sha)
                utils.subprocess_run(["git", "checkout", current_sha])

                try:
                    stats = get_stats(config.lang, config.ql_path)

                    csvwriter_total.writerow(
                        [current_sha, current_date, stats[0], stats[1], stats[2]])

                    for package in stats[3]:
                        csvwriter_packages.writerow(
                            [current_sha, current_date, package, stats[3][package]["sources"], stats[3][package]["sinks"], stats[3][package]["summaries"]])

                    print("Collected stats for " + current_sha +
                          " at " + current_date.isoformat())
                except:
                    print("Error getting stats for " +
                          current_sha + ". Stopping iteration.")
                    break

                current_sha, current_date = get_previous_sha(
                    current_sha, current_date)

    utils.subprocess_run(["git", "checkout", "main"])
