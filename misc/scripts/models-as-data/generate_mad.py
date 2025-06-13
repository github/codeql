#!/usr/bin/python3

import helpers
import os
import os.path
import subprocess
import sys
import tempfile
import re

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


def printHelp():
    print(f"""Usage:
python3 generate_mad.py <library-database> [DIR] --language LANGUAGE [--with-sinks] [--with-sources] [--with-summaries] [--with-neutrals] [--with-typebased-summaries] [--dry-run]

This generates summary, source, sink and neutral models for the code in the database.
The files will be placed in `LANGUAGE/ql/lib/ext/generated/DIR`

Which models are generated is controlled by the flags:
    --with-sinks
    --with-sources
    --with-summaries
    --with-neutrals
    --with-typebased-summaries (Experimental)
If none of these flags are specified, all models are generated except for the type based models.

    --dry-run: Only run the queries, but don't write to file.

Example invocations:
$ python3 generate_mad.py /tmp/dbs/my_library_db
$ python3 generate_mad.py /tmp/dbs/my_library_db --with-sinks
$ python3 generate_mad.py /tmp/dbs/my_library_db --with-sinks my_directory


Requirements: `codeql` should appear on your path.
    """)

class Generator:
    def __init__(self, language):
        self.language = language
        self.generateSinks = False
        self.generateSources = False
        self.generateSummaries = False
        self.generateNeutrals = False
        self.generateTypeBasedSummaries = False
        self.dryRun = False
        self.dirname = "modelgenerator"
        self.ram = 2**15
        self.threads = 8


    def setenvironment(self, database, folder):
        self.codeQlRoot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
        self.database = database
        self.generatedFrameworks = os.path.join(
            self.codeQlRoot, f"{self.language}/ql/lib/ext/generated/{folder}")
        self.workDir = tempfile.mkdtemp()
        os.makedirs(self.generatedFrameworks, exist_ok=True)


    @staticmethod
    def make():
        # Create a generator instance based on command line arguments.
        if any(s == "--help" for s in sys.argv):
            printHelp()
            sys.exit(0)

        if "--language" in sys.argv:
            language = sys.argv[sys.argv.index("--language") + 1]
            sys.argv.remove("--language")
            sys.argv.remove(language)
        else:
            printHelp()
            sys.exit(0)

        generator = Generator(language=language)

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

        if (not generator.generateSinks and
           not generator.generateSources and
           not generator.generateSummaries and
           not generator.generateNeutrals and
           not generator.generateTypeBasedSummaries):
            generator.generateSinks = generator.generateSources = generator.generateSummaries = generator.generateNeutrals = True

        n = len(sys.argv)
        if n < 2:
            printHelp()
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

        cmd = ['codeql', 'query', 'run', queryFile, '--database', self.database, '--output', resultBqrs]
        if self.threads is not None:
            cmd += ["--threads", str(self.threads)]
        if self.ram is not None:
            cmd += ["--ram", str(self.ram)]
        helpers.run_cmd(cmd, "Failed to generate " + query)

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
        summaryAddsTo = {}
        if self.generateSummaries:
            summaryAddsTo = self.getAddsTo("CaptureSummaryModels.ql", helpers.summaryModelPredicate)

        sinkAddsTo = {}
        if self.generateSinks:
            sinkAddsTo = self.getAddsTo("CaptureSinkModels.ql", helpers.sinkModelPredicate)

        sourceAddsTo = {}
        if self.generateSources:
            sourceAddsTo = self.getAddsTo("CaptureSourceModels.ql", helpers.sourceModelPredicate)

        neutralAddsTo = {}
        if self.generateNeutrals:
            neutralAddsTo = self.getAddsTo("CaptureNeutralModels.ql", helpers.neutralModelPredicate)

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
            # Replace problematic characters with dashes, and collapse multiple dashes.
            sanitizedEntry = re.sub(r'-+', '-', entry.replace('/', '-').replace(':', '-'))
            target = os.path.join(self.generatedFrameworks, sanitizedEntry + extension)
            with open(target, "w") as f:
                f.write(extensionTemplate.format(extensions[entry]))
            print("Models as data extensions written to " + target)


    def run(self):
        content = self.makeContent()
        typeBasedContent = self.makeTypeBasedContent()

        if self.dryRun:
            print("Models as data extensions generated, but not written to file.")
            sys.exit(0)

        if (self.generateSinks or
           self.generateSources or
           self.generateSummaries or
           self.generateNeutrals):
            self.save(content, ".model.yml")

        if self.generateTypeBasedSummaries:
            self.save(typeBasedContent, ".typebased.model.yml")

if __name__ == '__main__':
    Generator.make().run()
