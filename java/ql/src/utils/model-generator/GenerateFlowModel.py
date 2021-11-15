#!/usr/bin/python3

import json
import os
import os.path
import shlex
import subprocess
import sys
import tempfile


def printHelp():
    print("""Usage:
GenerateFlowModel.py <library-database> <outputQll> [--with-sinks] [--with-sources] [--with-summaries]

This generates summary, source and sink models for the code in the database.
The files will be placed in `java/ql/lib/semmle/code/java/frameworks/<outputQll>` where
outputQll is the name (and path) of the output QLL file. Usually, models are grouped by their
respective frameworks.

Which models are generated is controlled by the flags:
    --with-sinks
    --with-sources
    --with-summaries
If none of these flags are specified, all models are generated.

Example invocations:
$ GenerateFlowModel.py /tmp/dbs/apache_commons-codec_45649c8 "apache/Codec.qll"
$ GenerateFlowModel.py /tmp/dbs/jdk15_db "javase/jdk_sinks.qll" --with-sinks

Requirements: `codeql` should both appear on your path.
""")


if any(s == "--help" for s in sys.argv):
    printHelp()
    sys.exit(0)

generateSinks = False
generateSources = False
generateSummaries = False
if "--with-sinks" in sys.argv:
    sys.argv.remove("--with-sinks")
    generateSinks = True

if "--with-sources" in sys.argv:
    sys.argv.remove("--with-sources")
    generateSources = True

if "--with-summaries" in sys.argv:
    sys.argv.remove("--with-summaries")
    generateSummaries = True

if not generateSinks and not generateSources and not generateSummaries:
    generateSinks = generateSources = generateSummaries = True

if len(sys.argv) != 3:
    printHelp()
    sys.exit(1)

codeQlRoot = subprocess.check_output(
    ["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
targetQll = sys.argv[2]
if not targetQll.endswith(".qll"):
    targetQll += ".qll"
filename = os.path.basename(targetQll)
shortname = filename[:-4]
generatedFrameworks = os.path.join(
    codeQlRoot, "java/ql/lib/semmle/code/java/frameworks/")
frameworkTarget = os.path.join(generatedFrameworks, targetQll)

workDir = tempfile.mkdtemp()
os.makedirs(generatedFrameworks, exist_ok=True)


def runQuery(infoMessage, query):
    print("########## Querying " + infoMessage + "...")
    database = sys.argv[1]
    queryFile = os.path.join(os.path.dirname(
        __file__), query)
    resultBqrs = os.path.join(workDir, "out.bqrs")
    cmd = ['codeql', 'query', 'run', queryFile, '--database',
           database, '--output', resultBqrs, '--threads', '8']

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
    if rows.strip() == "":
        return ""
    return classTemplate.format(shortname[0].upper() + shortname[1:], kind.capitalize(), superclass, rows)


if generateSummaries:
    summaryRows = runQuery("summary models", "CaptureSummaryModels.ql")
    summaryCsv = asCsvModel("SummaryModelCsv", "summary", summaryRows)
else:
    summaryCsv = ""

if generateSinks:
    sinkRows = runQuery("sink models", "CaptureSinkModels.ql")
    sinkCsv = asCsvModel("SinkModelCsv", "sinks", sinkRows)
else:
    sinkCsv = ""

if generateSources:
    sourceRows = runQuery("source models", "CaptureSourceModels.ql")
    sourceCsv = asCsvModel("SourceModelCsv", "sources", sourceRows)
else:
    sourceCsv = ""

qllTemplate = """
/** Definitions of taint steps in the {0} framework */

import java
private import semmle.code.java.dataflow.ExternalFlow

{1}
{2}
{3}

"""


qllContents = qllTemplate.format(shortname, sinkCsv, sourceCsv, summaryCsv)


with open(frameworkTarget, "w") as frameworkQll:
    frameworkQll.write(qllContents)

cmd = ['codeql', 'query', 'format', '--in-place', frameworkTarget]
ret = subprocess.call(cmd)
if ret != 0:
    print("Failed to format query. Failed command was: " + shlex.join(cmd))
    sys.exit(1)

print("")
print("CSV model written to " + frameworkTarget)
