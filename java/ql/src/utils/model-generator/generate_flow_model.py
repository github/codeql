#!/usr/bin/python3

import json
import os
import os.path
import shlex
import subprocess
import sys
import tempfile

language = "java"

class Generator:
    def __init__ (self, language):
        self.language = language
        self.generateSinks = False
        self.generateSources = False
        self.generateSummaries = False
        self.dryRun = False

    def printHelp(self):
        print(f"""Usage:
python3 GenerateFlowModel.py <library-database> <outputQll> [--with-sinks] [--with-sources] [--with-summaries] [--dry-run]

This generates summary, source and sink models for the code in the database.
The files will be placed in `{self.language}/ql/lib/semmle/code/{self.language}/frameworks/<outputQll>` where
outputQll is the name (and path) of the output QLL file. Usually, models are grouped by their
respective frameworks.

Which models are generated is controlled by the flags:
    --with-sinks
    --with-sources
    --with-summaries
If none of these flags are specified, all models are generated.

    --dry-run: Only run the queries, but don't write to file.

Example invocations:
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db "mylibrary/Framework.qll"
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db "mylibrary/FrameworkSinks.qll" --with-sinks

Requirements: `codeql` should both appear on your path.
    """)


    def setenvironment(self, target, database):
        self.codeQlRoot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
        if not target.endswith(".qll"):
            target += ".qll"
        self.filename = os.path.basename(target)
        self.shortname = self.filename[:-4]
        self.database = database
        self.generatedFrameworks = os.path.join(
            self.codeQlRoot, f"{self.language}/ql/lib/semmle/code/{self.language}/frameworks/")
        self.frameworkTarget = os.path.join(self.generatedFrameworks, target)

        self.workDir = tempfile.mkdtemp()
        os.makedirs(self.generatedFrameworks, exist_ok=True)

    @staticmethod
    def make(language):
        generator = Generator(language)
        if any(s == "--help" for s in sys.argv):
            generator.printHelp()
            sys.exit(0)

        if "--with-sinks" in sys.argv:
            sys.argv.remove("--with-sinks")
            generator.generateSinks = True

        if "--with-sources" in sys.argv:
            sys.argv.remove("--with-sources")
            generator.generateSources = True

        if "--with-summaries" in sys.argv:
            sys.argv.remove("--with-summaries")
            generator.generateSummaries = True

        if "--dry-run" in sys.argv:
            sys.argv.remove("--dry-run")
            generator.dryRun = True

        if not generator.generateSinks and not generator.generateSources and not generator.generateSummaries:
            generator.generateSinks = generator.generateSources = generator.generateSummaries = True

        if len(sys.argv) != 3:
            generator.printHelp()
            sys.exit(1)
        
        generator.setenvironment(sys.argv[2], sys.argv[1])
        return generator

    def runQuery(self, infoMessage, query):
        print("########## Querying " + infoMessage + "...")
        queryFile = os.path.join(os.path.dirname(
            __file__), query)
        resultBqrs = os.path.join(self.workDir, "out.bqrs")
        cmd = ['codeql', 'query', 'run', queryFile, '--database',
               self.database, '--output', resultBqrs, '--threads', '8']

        ret = subprocess.call(cmd)
        if ret != 0:
            print("Failed to generate " + infoMessage +
                  ". Failed command was: " + shlex.join(cmd))
            sys.exit(1)
        return self.readRows(resultBqrs)


    def readRows(self, bqrsFile):
        generatedJson = os.path.join(self.workDir, "out.json")
        cmd = ['codeql', 'bqrs', 'decode', bqrsFile,
               '--format=json', '--output', generatedJson]
        ret = subprocess.call(cmd)
        if ret != 0:
            print("Failed to decode BQRS. Failed command was: " + shlex.join(cmd))
            sys.exit(1)

        with open(generatedJson) as f:
            results = json.load(f)

        try:
            results['#select']['tuples']
        except KeyError:
            print('Unexpected JSON output - no tuples found')
            exit(1)

        rows = ""
        for (row) in results['#select']['tuples']:
            rows += "            \"" + row[0] + "\",\n"

        return rows[:-2]


    def asCsvModel(self, superclass, kind, rows):
        classTemplate = """
private class {0}{1}Csv extends {2} {{
    override predicate row(string row) {{
        row =
            [
{3}
            ]
    }}
}}
        """
        if rows.strip() == "":
            return ""
        return classTemplate.format(self.shortname[0].upper() + self.shortname[1:], kind.capitalize(), superclass, rows)


generator = Generator.make(language)

if generator.generateSummaries:
    summaryRows = generator.runQuery("summary models", "CaptureSummaryModels.ql")
    summaryCsv = generator.asCsvModel("SummaryModelCsv", "summary", summaryRows)
else:
    summaryCsv = ""

if generator.generateSinks:
    sinkRows = generator.runQuery("sink models", "CaptureSinkModels.ql")
    sinkCsv = generator.asCsvModel("SinkModelCsv", "sinks", sinkRows)
else:
    sinkCsv = ""

if generator.generateSources:
    sourceRows = generator.runQuery("source models", "CaptureSourceModels.ql")
    sourceCsv = generator.asCsvModel("SourceModelCsv", "sources", sourceRows)
else:
    sourceCsv = ""

qllContents = f"""
/** Definitions of taint steps in the {generator.shortname} framework */

import {generator.language}
private import semmle.code.{generator.language}.dataflow.ExternalFlow

{sinkCsv}
{sourceCsv}
{summaryCsv}

"""

if generator.dryRun:
    print("CSV Models generated, but not written to file.")
    sys.exit(0)

with open(generator.frameworkTarget, "w") as frameworkQll:
    frameworkQll.write(qllContents)

cmd = ['codeql', 'query', 'format', '--in-place', generator.frameworkTarget]
ret = subprocess.call(cmd)
if ret != 0:
    print("Failed to format query. Failed command was: " + shlex.join(cmd))
    sys.exit(1)

print("")
print("CSV model written to " + generator.frameworkTarget)
