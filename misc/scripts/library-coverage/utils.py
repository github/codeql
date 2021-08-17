import subprocess
import os
import csv
import shlex
import sys


def subprocess_run(cmd):
    """Runs a command through subprocess.run, with a few tweaks. Raises an Exception if exit code != 0."""
    print(shlex.join(cmd))
    return subprocess.run(cmd, capture_output=True, text=True, env=os.environ.copy(), check=True)


def subprocess_check_output(cmd):
    """Runs a command through subprocess.check_output and returns its output"""
    print(shlex.join(cmd))
    return subprocess.check_output(cmd, text=True, env=os.environ.copy())


def create_empty_database(lang, extension, database):
    """Creates an empty database for the given language."""
    subprocess_run(["codeql", "database", "init", "--language=" + lang,
                   "--source-root=/tmp/empty", "--allow-missing-source-root", database])
    subprocess_run(["mkdir", "-p", database + "/src/tmp/empty"])
    subprocess_run(["touch", database + "/src/tmp/empty/empty" + extension])
    subprocess_run(["codeql", "database", "finalize",
                   database, "--no-pre-finalize"])


def run_codeql_query(query, database, output, search_path):
    """Runs a codeql query on the given database."""
    # --search-path is required when the CLI needs to upgrade the database scheme.
    subprocess_run(["codeql", "query", "run", query, "--database", database,
                   "--output", output + ".bqrs", "--search-path", search_path])
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


def check_file_exists(file):
    if not os.path.exists(file):
        print(f"Expected file '{file}' doesn't exist.", file=sys.stderr)
        return False
    return True


def download_artifact(repo, name, dir, run_id):
    subprocess_run(["gh", "run", "download", "--repo",
                    repo, "--name", name, "--dir", dir, str(run_id)])
