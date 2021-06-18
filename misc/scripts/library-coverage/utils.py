import subprocess
import os
import csv
import sys


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
    os.remove(output + ".bqrs")


class LanguageConfig:
    def __init__(self, lang, capitalized_lang, ext, ql_path):
        self.lang = lang
        self.capitalized_lang = capitalized_lang
        self.ext = ext
        self.ql_path = ql_path


def read_cwes(path):
    cwes = {}
    with open(path) as csvfile:
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
    return cwes
