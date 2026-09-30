# Helper functionality for MaD models extensions conversion.

import helpers
import os
import shutil
import subprocess
import sys
import tempfile

class Converter:
    def __init__(self, language, dbDir):
        self.language = language
        self.dbDir = dbDir
        self.codeQlRoot = (
            subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
            .decode("utf-8")
            .strip()
        )
        self.extDir = os.path.join(self.codeQlRoot, f"{self.language}/ql/lib/ext/")
        self.dirname = "modelconverter"
        self.modelFileExtension = ".model.json"
        self.workDir = tempfile.mkdtemp()

    def runQuery(self, query):
        print("########## Querying: ", query)
        queryFile = os.path.join(
            self.codeQlRoot, f"{self.language}/ql/src/utils/{self.dirname}", query
        )
        resultBqrs = os.path.join(self.workDir, "out.bqrs")

        helpers.run_cmd(
            [
                "codeql",
                "query",
                "run",
                queryFile,
                "--database",
                self.dbDir,
                "--output",
                resultBqrs,
            ],
            "Failed to generate " + query,
        )
        return helpers.readData(self.workDir, resultBqrs)

    def merge_query_results(self, query, predicate, mergers):
        data = self.runQuery(query)
        for row in data:
            provenance = row[-1]
            namespace = row[0]
            target_merger = mergers[1] if provenance.endswith("generated") else mergers[0]
            target_merger.add_row(namespace, predicate, row)

    def make_extensions(self):
        mergers = [
            helpers.ExtensionMerger(f"codeql/{self.language}-all"),
            helpers.ExtensionMerger(f"codeql/{self.language}-all"),
        ]
        self.merge_query_results("ExtractSummaries.ql", helpers.summaryModelPredicate, mergers)
        self.merge_query_results("ExtractSources.ql", helpers.sourceModelPredicate, mergers)
        self.merge_query_results("ExtractSinks.ql", helpers.sinkModelPredicate, mergers)
        self.merge_query_results("ExtractNeutrals.ql", helpers.neutralModelPredicate, mergers)
        return mergers

    def run(self):
        mergers = self.make_extensions()

        # Create directory if it doesn't exist
        os.makedirs(self.extDir, exist_ok=True)

        mergers[0].save(self.extDir, self.modelFileExtension)
        mergers[1].save(self.extDir + "/generated", self.modelFileExtension)
