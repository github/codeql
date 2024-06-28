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
    return row[0].upper() + row[1:]

def parseData(data):
    rows = { }

    for row in data:
        d = row[0].split(';')
        namespace = d[0]
        d = map(quote_if_needed, d)
        helpers.insert_update(rows, namespace, "      - [" + ', '.join(d) + ']\n')

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
python3 GenerateFlowModel.py <library-database> [DIR] [--with-sinks] [--with-sources] [--with-summaries] [--with-neutrals] [--with-typebased-summaries] [--dry-run]

This generates summary, source, sink and neutral models for the code in the database.
The files will be placed in `{self.language}/ql/lib/ext/generated/DIR`

Which models are generated is controlled by the flags:
    --with-sinks
    --with-sources
    --with-summaries
    --with-neutrals
    --with-typebased-summaries (Experimental)
If none of these flags are specified, all models are generated except for the type based models.

    --dry-run: Only run the queries, but don't write to file.

Example invocations:
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db --with-sinks
$ python3 GenerateFlowModel.py /tmp/dbs/my_library_db --with-sinks my_directory


Requirements: `codeql` should both appear on your path.
    """)


    def setenvironment(self, database, folder):
        self.codeQlRoot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
        self.database = database
        self.generatedFrameworks = os.path.join(
            self.codeQlRoot, f"{self.language}/ql/lib/ext/generated/{folder}")
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

        n = len(sys.argv)
        if n < 2:
            generator.printHelp()
            sys.exit(1)
        elif n == 2:
            generator.setenvironment(sys.argv[1], "")
        else:
            generator.setenvironment(sys.argv[1], sys.argv[2])

        return generator
    

    def runQuery(self, query):
        print("########## Querying " + query + "...")
        queryFile = os.path.join(self.codeQlRoot, f"{self.language}/ql/src/utils/{self.dirname}", query)
        resultBqrs = os.path.join(self.workDir, "out.bqrs")

        helpers.run_cmd(['codeql', 'query', 'run', queryFile, '--database',
               self.database, '--output', resultBqrs, '--threads', '8', '--ram', '32768'], "Failed to generate " + query)

        return helpers.readData(self.workDir, resultBqrs)


    def asAddsTo(self, rows, predicate):
        extensions = { }
        for key in rows:
            extensions[key] = helpers.addsToTemplate.format(f"codeql/{self.language}-all", predicate, rows[key])
        return extensions

    def getAddsTo(self, query, predicate):
        data = self.runQuery(query)
        rows = parseData(data)
        return self.asAddsTo(rows, predicate)

    def makeContent(self):
        if self.generateSummaries:
            summaryAddsTo = self.getAddsTo("CaptureSummaryModels.ql", helpers.summaryModelPredicate)
        else:
            summaryAddsTo = { }

        if self.generateSinks:
            sinkAddsTo = self.getAddsTo("CaptureSinkModels.ql", helpers.sinkModelPredicate)
        else:
            sinkAddsTo = { }

        if self.generateSources:
            sourceAddsTo = self.getAddsTo("CaptureSourceModels.ql", helpers.sourceModelPredicate)
        else:
            sourceAddsTo = {}

        if self.generateNeutrals:
            neutralAddsTo = self.getAddsTo("CaptureNeutralModels.ql", helpers.neutralModelPredicate)
        else:
            neutralAddsTo = { }
        
        return helpers.merge(summaryAddsTo, sinkAddsTo, sourceAddsTo, neutralAddsTo)

    def makeTypeBasedContent(self):
        if self.generateTypeBasedSummaries:
            typeBasedSummaryAddsTo = self.getAddsTo("CaptureTypeBasedSummaryModels.ql", helpers.summaryModelPredicate)
        else:
            typeBasedSummaryAddsTo = { }

        return typeBasedSummaryAddsTo

    def save(self, extensions, extension):
        # Create a file for each namespace and save models.
        extensionTemplate = """# THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
extensions:
{0}"""
        for entry in extensions:
            target = os.path.join(self.generatedFrameworks, entry + extension)
            with open(target, "w") as f:
                f.write(extensionTemplate.format(extensions[entry]))
            print("Models as data extensions written to " + target)


    def run(self):
        content = self.makeContent()
        typeBasedContent = self.makeTypeBasedContent()

        if self.dryRun:
            print("Models as data extensions generated, but not written to file.")
            sys.exit(0)
        
        if self.generateSinks or self.generateSinks or self.generateSummaries:
            self.save(content, ".model.yml")

        if self.generateTypeBasedSummaries:
            self.save(typeBasedContent, ".typebased.model.yml")
