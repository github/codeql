#!/usr/bin/python3

import helpers
import os
import os.path
import subprocess
import sys
import tempfile
import re
import argparse


def quote_if_needed(row):
    if row != "true" and row != "false":
        return '"' + row + '"'
    # subtypes column
    return row[0].upper() + row[1:]


def parseData(data):
    rows = {}

    for row in data:
        d = row[0].split(";")
        namespace = d[0]
        d = map(quote_if_needed, d)
        helpers.insert_update(rows, namespace, "      - [" + ", ".join(d) + "]\n")

    return rows


description = """\
This generates summary, source, sink and neutral models for the code in the database.
The files will be placed in `LANGUAGE/ql/lib/ext/generated/DIR`"""

epilog = """\
Example invocations:
$ python3 generate_mad.py /tmp/dbs/my_library_db
$ python3 generate_mad.py /tmp/dbs/my_library_db --with-sinks
$ python3 generate_mad.py /tmp/dbs/my_library_db --with-sinks my_directory

Requirements: `codeql` should appear on your path."""


class Generator:
    with_sinks = False
    with_sources = False
    with_summaries = False
    with_neutrals = False
    with_typebased_summaries = False
    dry_run = False
    dirname = "modelgenerator"
    ram = None
    threads = 0
    folder = ""
    single_file = None

    def __init__(self, language=None):
        self.language = language

    def setenvironment(self, database=None, folder=None):
        self.codeql_root = (
            subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
            .decode("utf-8")
            .strip()
        )
        self.database = database or self.database
        self.folder = folder or self.folder
        self.generated_frameworks = os.path.join(
            self.codeql_root, f"{self.language}/ql/lib/ext/generated/{self.folder}"
        )
        self.workDir = tempfile.mkdtemp()
        if self.ram is None:
            threads = self.threads if self.threads > 0 else os.cpu_count()
            self.ram = 2048 * threads
        os.makedirs(self.generated_frameworks, exist_ok=True)

    @staticmethod
    def make():
        p = argparse.ArgumentParser(
            description=description,
            formatter_class=argparse.RawTextHelpFormatter,
            epilog=epilog,
        )
        p.add_argument("database", help="Path to the CodeQL database")
        p.add_argument(
            "folder",
            nargs="?",
            default="",
            help="Optional folder to place the generated files in",
        )
        p.add_argument(
            "--language",
            required=True,
            help="The language for which to generate models",
        )
        p.add_argument(
            "--with-sinks",
            action="store_true",
            help="Generate sink models",
        )
        p.add_argument(
            "--with-sources",
            action="store_true",
            help="Generate source models",
        )
        p.add_argument(
            "--with-summaries",
            action="store_true",
            help="Generate summary models",
        )
        p.add_argument(
            "--with-neutrals",
            action="store_true",
            help="Generate neutral models",
        )
        p.add_argument(
            "--with-typebased-summaries",
            action="store_true",
            help="Generate type-based summary models (experimental)",
        )
        p.add_argument(
            "--dry-run",
            action="store_true",
            help="Do not write the generated files, just print them to stdout",
        )
        p.add_argument(
            "--threads",
            type=int,
            default=Generator.threads,
            help="Number of threads to use for CodeQL queries (default %(default)s). `0` means use all available threads.",
        )
        p.add_argument(
            "--ram",
            type=int,
            help="Amount of RAM to use for CodeQL queries in MB. Default is to use 2048 MB per thread.",
        )
        p.add_argument(
            "--single-file",
            help="Generate a single file with all models instead of separate files for each namespace, using provided argument as the base filename.",
        )
        generator = p.parse_args(namespace=Generator())

        if (
            not generator.with_sinks
            and not generator.with_sources
            and not generator.with_summaries
            and not generator.with_neutrals
            and not generator.with_typebased_summaries
        ):
            generator.with_sinks = True
            generator.with_sources = True
            generator.with_summaries = True
            generator.with_neutrals = True

        generator.setenvironment()
        return generator

    def runQuery(self, query):
        print("########## Querying " + query + "...")
        queryFile = os.path.join(
            self.codeql_root, f"{self.language}/ql/src/utils/{self.dirname}", query
        )
        resultBqrs = os.path.join(self.workDir, "out.bqrs")

        cmd = [
            "codeql",
            "query",
            "run",
            queryFile,
            "--database",
            self.database,
            "--output",
            resultBqrs,
            "--threads",
            str(self.threads),
            "--ram",
            str(self.ram),
        ]
        helpers.run_cmd(cmd, "Failed to generate " + query)

        return helpers.readData(self.workDir, resultBqrs)

    def asAddsTo(self, rows, predicate):
        extensions = {}
        for key in rows:
            extensions[key] = helpers.addsToTemplate.format(
                f"codeql/{self.language}-all", predicate, rows[key]
            )
        return extensions

    def getAddsTo(self, query, predicate):
        data = self.runQuery(query)
        rows = parseData(data)
        if self.single_file and rows:
            rows = {self.single_file: "".join(rows.values())}
        return self.asAddsTo(rows, predicate)

    def makeContent(self):
        summaryAddsTo = {}
        if self.with_summaries:
            summaryAddsTo = self.getAddsTo(
                "CaptureSummaryModels.ql", helpers.summaryModelPredicate
            )

        sinkAddsTo = {}
        if self.with_sinks:
            sinkAddsTo = self.getAddsTo(
                "CaptureSinkModels.ql", helpers.sinkModelPredicate
            )

        sourceAddsTo = {}
        if self.with_sources:
            sourceAddsTo = self.getAddsTo(
                "CaptureSourceModels.ql", helpers.sourceModelPredicate
            )

        neutralAddsTo = {}
        if self.with_neutrals:
            neutralAddsTo = self.getAddsTo(
                "CaptureNeutralModels.ql", helpers.neutralModelPredicate
            )

        return helpers.merge(summaryAddsTo, sinkAddsTo, sourceAddsTo, neutralAddsTo)

    def makeTypeBasedContent(self):
        if self.with_typebased_summaries:
            typeBasedSummaryAddsTo = self.getAddsTo(
                "CaptureTypeBasedSummaryModels.ql", helpers.summaryModelPredicate
            )
        else:
            typeBasedSummaryAddsTo = {}

        return typeBasedSummaryAddsTo

    def save(self, extensions, extension):
        # Create a file for each namespace and save models.
        extensionTemplate = """# THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
extensions:
{0}"""
        for entry in extensions:
            # Replace problematic characters with dashes, and collapse multiple dashes.
            sanitizedEntry = re.sub(
                r"-+", "-", entry.replace("/", "-").replace(":", "-")
            )
            target = os.path.join(self.generated_frameworks, sanitizedEntry + extension)
            with open(target, "w") as f:
                f.write(extensionTemplate.format(extensions[entry]))
            print("Models as data extensions written to " + target)

    def run(self):
        content = self.makeContent()
        typeBasedContent = self.makeTypeBasedContent()

        if self.dry_run:
            print("Models as data extensions generated, but not written to file.")
            sys.exit(0)

        if (
            self.with_sinks
            or self.with_sources
            or self.with_summaries
            or self.with_neutrals
        ):
            self.save(content, ".model.yml")

        if self.with_typebased_summaries:
            self.save(typeBasedContent, ".typebased.model.yml")


if __name__ == "__main__":
    Generator.make().run()
