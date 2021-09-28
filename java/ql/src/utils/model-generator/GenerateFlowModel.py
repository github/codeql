#!/usr/bin/python3

import errno
import json
import os
import os.path
import re
import shlex
import shutil
import subprocess
import sys
import tempfile


def printHelp():
    print("""Usage:
GenerateFlowModel.py <library-database> "simpleName"

This generates summary, source and sink models for the code in the database.
The files will be placed in `java/ql/lib/semmle/code/java/frameworks/generated/<simpleName>/`

A simple name is used for the generated target files (e.g. `simpleName.qll`).

Requirements: `codeql` should both appear on your path.
""")


if any(s == "--help" for s in sys.argv):
    printHelp()
    sys.exit(0)

withTests = False
if "--with-tests" in sys.argv:
    sys.argv.remove("--with-tests")
    withTests = True

if len(sys.argv) != 3:
    printHelp()
    sys.exit(1)

codeQlRoot = subprocess.check_output(
    ["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
shortname = sys.argv[2]
generatedFrameworks = os.path.join(
    codeQlRoot, "java/ql/lib/semmle/code/java/frameworks/generated/")
frameworkTarget = os.path.join(generatedFrameworks, shortname + ".qll")

workDir = tempfile.mkdtemp()
os.makedirs(generatedFrameworks, exist_ok=True)


def runQuery(infoMessage, query):
    print("########## Querying " + infoMessage + "...")
    database = sys.argv[1]
    queryFile = os.path.join(os.path.dirname(
        __file__), query)
    resultBqrs = os.path.join(workDir, "out.bqrs")
    cmd = ['codeql', 'query', 'run', queryFile, '--database',
           database, '--output', resultBqrs]

    ret = subprocess.call(cmd)
    if ret != 0:
        print("Failed to generate " + infoMessage +
              ". Failed command was: " + shlex.join(cmd))
        sys.exit(1)
    return readRows(resultBqrs)


def readRows(bqrsFile):
    generatedJson = os.path.join(workDir, "out.json")
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


def asCsvModel(superclass, kind, rows):
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
    return classTemplate.format(shortname.capitalize(), kind.capitalize(), superclass, rows)


summaryRows = runQuery("summary models", "CaptureSummaryModels.ql")
summaryCsv = asCsvModel("SummaryModelCsv", "summary", summaryRows)

sinkRows = runQuery("sink models", "CaptureSinkModels.ql")
sinkCsv = asCsvModel("SinkModelCsv", "sinks", sinkRows)


qllTemplate = """
/** Definitions of taint steps in the {0} framework */

import java
private import semmle.code.java.dataflow.ExternalFlow

{1}
{2}

"""


qllContents = qllTemplate.format(shortname, summaryCsv, sinkCsv)


with open(frameworkTarget, "w") as frameworkQll:
    frameworkQll.write(qllContents)
