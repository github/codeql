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

# the directory where codeql is. This is the directory where we change the SHAs
working_dir = sys.argv[1]

lang = "java"
db = "empty-java"
ql_output = "output-java.csv"
csv_output = "timeseries-java.csv"


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


def get_stats():
    if os.path.isdir(db):
        shutil.rmtree(db)
    utils.create_empty_database(lang, ".java", db)
    utils.run_codeql_query(
        "java/ql/src/meta/frameworks/Coverage.ql", db, ql_output)
    shutil.rmtree(db)

    sources = 0
    sinks = 0
    summaries = 0

    with open(ql_output) as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            # row: "android.util",1,"remote","source",16
            if row[3] == "source":
                sources += int(row[4])
            if row[3] == "sink":
                sinks += int(row[4])
            if row[3] == "summary":
                summaries += int(row[4])

    os.remove(ql_output)

    return (sources, sinks, summaries)


with open(csv_output, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    csvwriter.writerow(["SHA", "Date", "Sources", "Sinks", "Summaries"])

    os.chdir(working_dir)

    utils.subprocess_run(["git", "checkout", "main"])

    current_sha = get_str_output(["git", "rev-parse", "HEAD"])
    current_date = get_date(current_sha)

    while True:
        print("Getting stats for " + current_sha)
        utils.subprocess_run(["git", "checkout", current_sha])

        try:
            stats = get_stats()

            csvwriter.writerow(
                [current_sha, current_date, stats[0], stats[1], stats[2]])

            print("Collected stats for " + current_sha +
                  " at " + current_date.isoformat())
        except:
            print("Unexpected error:", sys.exc_info()[0])

            if os.path.isdir(db):
                shutil.rmtree(db)
            print("Error getting stats for " +
                  current_sha + ". Stopping iteration.")
            break

        current_sha, current_date = get_previous_sha(current_sha, current_date)

utils.subprocess_run(["git", "checkout", "main"])
