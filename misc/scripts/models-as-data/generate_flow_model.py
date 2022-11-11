#!/usr/bin/python3

import json
import os
import os.path
import shlex
import subprocess
import sys
import tempfile

class Generator:
    def __init__ (self, language):
        self.language = language
        self.generateSinks = False
        self.generateSources = False
        self.generateSummaries = False
        self.generateNegativeSummaries = False
        self.generateTypeBasedSummaries = False
        self.dryRun = False


    def printHelp(self):
        print(f"""Usage:
python3 GenerateFlowModel.py <library-database> <outputQll> [<friendlyFrameworkName>] [--with-sinks] [--with-sources] [--with-summaries] [--with-typebased-summaries] [--dry-run]

This generates summary, source and sink models for the code in the database.
The files will be placed in `{self.language}/ql/lib/semmle/code/{self.language}/frameworks/<outputQll>` where
outputQll is the name (and path) of the output QLL file. Usually, models are grouped by their
respective frameworks.
If negative summaries are produced a file prefixed with `Negative` will be generated and stored in the same folder.

Which models are generated is controlled by the flags:
    --with-sinks
    --with-sources
    --with-summaries
    --with-negative-summaries
    --with-typebased-summaries
If none of these flags are specified, all models are generated.

    --dry-run: Only run the queries, but don't write to file.

Example invocations:
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db "mylibrary/Framework.qll"
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db "mylibrary/Framework.qll" "Friendly Name of Framework"
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db "mylibrary/FrameworkSinks.qll" --with-sinks

Requirements: `codeql` should both appear on your path.
    """)


    def setenvironment(self, target, database, friendlyName):
        self.codeQlRoot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
        if not target.endswith(".qll"):
            target += ".qll"
        filename = os.path.basename(target)
        dirname = os.path.dirname(target)
        if friendlyName is not None:
            self.friendlyname = friendlyName
        else:
            self.friendlyname = filename[:-4]
        self.shortname = filename[:-4]
        self.database = database
        self.generatedFrameworks = os.path.join(
            self.codeQlRoot, f"{self.language}/ql/lib/semmle/code/{self.language}/frameworks/")
        self.frameworkTarget = os.path.join(self.generatedFrameworks, dirname, filename)
        self.negativeFrameworkTarget = os.path.join(self.generatedFrameworks, dirname, "Negative" + filename)
        self.typeBasedFrameworkTarget = os.path.join(self.generatedFrameworks, dirname, "TypeBased" + filename)

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

        if "--with-negative-summaries" in sys.argv:
            sys.argv.remove("--with-negative-summaries")
            generator.generateNegativeSummaries = True

        if "--with-typebased-summaries" in sys.argv:
            sys.argv.remove("--with-typebased-summaries")
            generator.generateTypeBasedSummaries = True

        if "--dry-run" in sys.argv:
            sys.argv.remove("--dry-run")
            generator.dryRun = True

        if not generator.generateSinks and not generator.generateSources and not generator.generateSummaries and not generator.generateNegativeSummaries and not generator.generateTypeBasedSummaries:
            generator.generateSinks = generator.generateSources = generator.generateSummaries = generator.generateNegativeSummaries = True

        if len(sys.argv) < 3 or len(sys.argv) > 4:
            generator.printHelp()
            sys.exit(1)

        friendlyName = None
        if len(sys.argv) == 4:
            friendlyName = sys.argv[3]

        generator.setenvironment(sys.argv[2], sys.argv[1], friendlyName)
        return generator


    def runQuery(self, infoMessage, query):
        print("########## Querying " + infoMessage + "...")
        queryFile = os.path.join(self.codeQlRoot, f"{self.language}/ql/src/utils/model-generator", query)
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


    def makeContent(self):
        if self.generateSummaries:
            summaryRows = self.runQuery("summary models", "CaptureSummaryModels.ql")
            summaryCsv = self.asCsvModel("SummaryModelCsv", "summary", summaryRows)
        else:
            summaryCsv = ""

        if self.generateSinks:
            sinkRows = self.runQuery("sink models", "CaptureSinkModels.ql")
            sinkCsv = self.asCsvModel("SinkModelCsv", "sinks", sinkRows)
        else:
            sinkCsv = ""

        if self.generateSources:
            sourceRows = self.runQuery("source models", "CaptureSourceModels.ql")
            sourceCsv = self.asCsvModel("SourceModelCsv", "sources", sourceRows)
        else:
            sourceCsv = ""

        return f"""
/** 
 * THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
 * Definitions of taint steps in the {self.friendlyname} framework.
 */

import {self.language}
private import semmle.code.{self.language}.dataflow.ExternalFlow

{sinkCsv}
{sourceCsv}
{summaryCsv}

        """

    def makeNegativeContent(self):
        if self.generateNegativeSummaries:
            negativeSummaryRows = self.runQuery("negative summary models", "CaptureNegativeSummaryModels.ql")
            negativeSummaryCsv = self.asCsvModel("NegativeSummaryModelCsv", "NegativeSummary", negativeSummaryRows)
        else:
            negativeSummaryCsv = ""

        return f"""
/**
 * THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
 * Definitions of negative summaries in the {self.friendlyname} framework.
 */

import {self.language}
private import semmle.code.{self.language}.dataflow.ExternalFlow

{negativeSummaryCsv}

        """

    def makeTypeBasedContent(self):
        if self.generateTypeBasedSummaries:
            typeBasedSummaryRows = self.runQuery("type based summary models", "CaptureTypeBasedSummaryModels.ql")
            typeBasedSummaryCsv = self.asCsvModel("SummaryModelCsv", "TypeBasedSummary", typeBasedSummaryRows)
        else:
            typeBasedSummaryCsv = ""

        return f"""
/**
 * THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
 * Definitions of type based summaries in the {self.friendlyname} framework.
 */

import {self.language}
private import semmle.code.{self.language}.dataflow.ExternalFlow

{typeBasedSummaryCsv}

        """

    def save(self, content, target):
        with open(target, "w") as targetQll:
            targetQll.write(content)

        cmd = ['codeql', 'query', 'format', '--in-place', target]
        ret = subprocess.call(cmd)
        if ret != 0:
            print("Failed to format query. Failed command was: " + shlex.join(cmd))
            sys.exit(1)

        print("")
        print("CSV model written to " + target)


    def run(self):
        content = self.makeContent()
        negativeContent = self.makeNegativeContent()
        typeBasedContent = self.makeTypeBasedContent()

        if self.dryRun:
            print("CSV Models generated, but not written to file.")
            sys.exit(0)
        
        if self.generateSinks or self.generateSinks or self.generateSummaries:
            self.save(content, self.frameworkTarget)

        if self.generateNegativeSummaries:
            self.save(negativeContent, self.negativeFrameworkTarget)

        if self.generateTypeBasedSummaries:
            self.save(typeBasedContent, self.typeBasedFrameworkTarget)
