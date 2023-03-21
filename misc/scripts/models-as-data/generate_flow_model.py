#!/usr/bin/python3

import helpers
import json
import os
import os.path
import shlex
import subprocess
import sys
import tempfile

def quote_if_needed(row):
    if row != "true" and row != "false":
        return "\"" + row + "\""
    # subtypes column
    return row

def parseData(data):
    rows = ""
    for (row) in data:
        d = row[0].split(';')
        d = map(quote_if_needed, d)
        rows += "      - [" + ', '.join(d) + ']\n'

    return rows

class Generator:
    def __init__ (self, language):
        self.language = language
        self.generateSinks = False
        self.generateSources = False
        self.generateSummaries = False
        self.generateNeutrals = False
        self.generateTypeBasedSummaries = False
        self.dryRun = False
        self.dirname = "modelgenerator"


    def printHelp(self):
        print(f"""Usage:
python3 GenerateFlowModel.py <library-database> <outputYml> [<friendlyFrameworkName>] [--with-sinks] [--with-sources] [--with-summaries] [--with-typebased-summaries] [--dry-run]

This generates summary, source and sink models for the code in the database.
The files will be placed in `{self.language}/ql/lib/ext/generated/<outputYml>.model.yml` where
outputYml is the name (and path) of the output YAML file. Usually, models are grouped by their
respective frameworks.

Which models are generated is controlled by the flags:
    --with-sinks
    --with-sources
    --with-summaries
    --with-neutrals
    --with-typebased-summaries (Experimental)
If none of these flags are specified, all models are generated except for the type based models.

    --dry-run: Only run the queries, but don't write to file.

Example invocations:
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db mylibrary
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db mylibrary "Friendly Name of Framework"
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db --with-sinks

Requirements: `codeql` should both appear on your path.
    """)


    def setenvironment(self, target, database, friendlyName):
        self.codeQlRoot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
        if not target.endswith(".model.yml"):
            target += ".model.yml"
        filename = os.path.basename(target)
        if friendlyName is not None:
            self.friendlyname = friendlyName
        else:
            self.friendlyname = filename[:-10]
        self.shortname = filename[:-10]
        self.database = database
        self.generatedFrameworks = os.path.join(
            self.codeQlRoot, f"{self.language}/ql/lib/ext/generated/")
        self.frameworkTarget = os.path.join(self.generatedFrameworks, filename)
        self.typeBasedFrameworkTarget = os.path.join(self.generatedFrameworks, "TypeBased" + filename)
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

        if "--with-neutrals" in sys.argv:
            sys.argv.remove("--with-neutrals")
            generator.generateNeutrals = True

        if "--with-typebased-summaries" in sys.argv:
            sys.argv.remove("--with-typebased-summaries")
            generator.generateTypeBasedSummaries = True

        if "--dry-run" in sys.argv:
            sys.argv.remove("--dry-run")
            generator.dryRun = True

        if not generator.generateSinks and not generator.generateSources and not generator.generateSummaries and not generator.generateNeutrals and not generator.generateTypeBasedSummaries:
            generator.generateSinks = generator.generateSources = generator.generateSummaries = generator.generateNeutrals = True

        if len(sys.argv) < 3 or len(sys.argv) > 4:
            generator.printHelp()
            sys.exit(1)

        friendlyName = None
        if len(sys.argv) == 4:
            friendlyName = sys.argv[3]

        generator.setenvironment(sys.argv[2], sys.argv[1], friendlyName)
        return generator
    

    def runQuery(self, query):
        print("########## Querying " + query + "...")
        queryFile = os.path.join(self.codeQlRoot, f"{self.language}/ql/src/utils/{self.dirname}", query)
        resultBqrs = os.path.join(self.workDir, "out.bqrs")

        helpers.run_cmd(['codeql', 'query', 'run', queryFile, '--database',
               self.database, '--output', resultBqrs, '--threads', '8'], "Failed to generate " + query)

        return helpers.readData(self.workDir, resultBqrs)


    def asAddsTo(self, rows, predicate):
        if rows.strip() == "":
            return ""
        return helpers.addsToTemplate.format(f"codeql/{self.language}-all", predicate, rows)


    def getAddsTo(self, query, predicate):
        data = self.runQuery(query)
        rows = parseData(data)
        return self.asAddsTo(rows, predicate)


    def makeContent(self):
        if self.generateSummaries:
            summaryAddsTo = self.getAddsTo("CaptureSummaryModels.ql", helpers.summaryModelPredicate)
        else:
            summaryAddsTo = ""

        if self.generateSinks:
            sinkAddsTo = self.getAddsTo("CaptureSinkModels.ql", helpers.sinkModelPredicate)
        else:
            sinkAddsTo = ""

        if self.generateSources:
            sourceAddsTo = self.getAddsTo("CaptureSourceModels.ql", helpers.sourceModelPredicate)
        else:
            sourceAddsTo = ""

        if self.generateNeutrals:
            neutralAddsTo = self.getAddsTo("CaptureNeutralModels.ql", helpers.neutralModelPredicate)
        else:
            neutralAddsTo = ""
        
        return f"""# THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
# Definitions of models for the {self.friendlyname} framework.
extensions:
{sinkAddsTo}{sourceAddsTo}{summaryAddsTo}{neutralAddsTo}"""

    def makeTypeBasedContent(self):
        if self.generateTypeBasedSummaries:
            typeBasedSummaryAddsTo = self.getAddsTo("CaptureTypeBasedSummaryModels.ql", "extSummaryModel")
        else:
            typeBasedSummaryAddsTo = ""

        return f"""# THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
# Definitions of type based summaries in the {self.friendlyname} framework.
extensions:
{typeBasedSummaryAddsTo}"""

    def save(self, content, target):
        with open(target, "w") as targetYml:
            targetYml.write(content)
        print("Models as data extensions written to " + target)


    def run(self):
        content = self.makeContent()
        typeBasedContent = self.makeTypeBasedContent()

        if self.dryRun:
            print("Models as data extensions generated, but not written to file.")
            sys.exit(0)
        
        if self.generateSinks or self.generateSinks or self.generateSummaries:
            self.save(content, self.frameworkTarget)

        if self.generateTypeBasedSummaries:
            self.save(typeBasedContent, self.typeBasedFrameworkTarget)
