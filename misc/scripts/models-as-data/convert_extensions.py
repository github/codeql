# Helper functionality for MaD models extensions conversion.

import helpers
import os
import shutil
import subprocess
import sys
import tempfile


def quote_if_needed(v):
    # string columns
    if type(v) is str:
        return "\"" + v + "\""
    # bool column
    return str(v)

def insert_update(rows, key, value):
    if key in rows:
        rows[key] += value
    else:
        rows[key] = value

def merge(*dicts):
    merged = {}
    for d in dicts:
        for entry in d:
            insert_update(merged, entry, d[entry])
    return merged

def parseData(data):
    rows = { }
    for row in data:
        d = map(quote_if_needed, row)
        insert_update(rows, row[0], "      - [" + ', '.join(d) + ']\n')

    return rows

class Converter:
    def __init__(self, language, dbDir):
        self.language = language
        self.dbDir = dbDir
        self.codeQlRoot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
        self.extDir = os.path.join(self.codeQlRoot, f"{self.language}/ql/lib/ext/")
        self.dirname = "modelconverter"
        self.modelFileExtension = ".model.yml"
        self.workDir = tempfile.mkdtemp()


    def runQuery(self, query):
        print('########## Querying: ', query)
        queryFile = os.path.join(self.codeQlRoot, f"{self.language}/ql/src/utils/{self.dirname}", query)
        resultBqrs = os.path.join(self.workDir, "out.bqrs")

        helpers.run_cmd(['codeql', 'query', 'run', queryFile, '--database', self.dbDir, '--output', resultBqrs], "Failed to generate " + query)
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
        summaries = self.getAddsTo("ExtractSummaries.ql", helpers.summaryModelPredicate)
        sources = self.getAddsTo("ExtractSources.ql", helpers.sourceModelPredicate)
        sinks = self.getAddsTo("ExtractSinks.ql", helpers.sinkModelPredicate)
        neutrals = self.getAddsTo("ExtractNeutrals.ql", helpers.neutralModelPredicate)
        return merge(sources, sinks, summaries, neutrals)


    def save(self, extensions):
        # Create directory if it doesn't exist
        os.makedirs(self.extDir, exist_ok=True)

        # Create a file for each namespace and save models.
        extensionTemplate = """extensions:
{0}"""
        for entry in extensions:
            with open(self.extDir + "/" + entry + self.modelFileExtension, "w") as f:
                f.write(extensionTemplate.format(extensions[entry]))

    def run(self):
        extensions = self.makeContent()
        self.save(extensions)
