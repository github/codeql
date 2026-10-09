import json
import os
import shutil
import subprocess
import re
import data_extension_file

# Shared strings.
summaryModelPredicate = "summaryModel"
sinkModelPredicate = "sinkModel"
sourceModelPredicate = "sourceModel"
neutralModelPredicate = "neutralModel"


# Helper class for accumulating tuples grouped by namespace and predicate, and generating data
# extensions for them.
class ExtensionMerger:
    def __init__(self, pack):
        self.pack = pack
        self.namespaces = {}

    def add_row(self, namespace, predicate, row):
        if namespace not in self.namespaces:
            self.namespaces[namespace] = {}
        if predicate not in self.namespaces[namespace]:
            self.namespaces[namespace][predicate] = []
        self.namespaces[namespace][predicate].append(row)

    # Helper function to yield unique elements from a sorted list.
    def uniq(self, sorted_list):
        last = None
        for element in sorted_list:
            if element == last:
                continue
            yield element
            last = element

    def save(self, dir, file_extension):
        # Create a file for each namespace and save models.
        for namespace in self.namespaces:
            # Sort and deduplicate rows for each predicate within this namespace.
            for predicate in self.namespaces[namespace]:
                l = self.namespaces[namespace][predicate]
                self.namespaces[namespace][predicate] = list(self.uniq(sorted(l)))
            extension = data_extension_file.DataExtensionFile(self.pack)
            for predicate in self.namespaces[namespace]:
                extension.add_rows(predicate, self.namespaces[namespace][predicate])
            # Replace problematic characters with dashes, and collapse multiple dashes.
            sanitized_namespace = re.sub(
                r"-+", "-", namespace.replace("/", "-").replace(":", "-")
            )
            target = os.path.join(dir, f"{sanitized_namespace}{file_extension}")
            with open(target, "w") as f:
                extension.write_yaml(f)
            print("Models as data extensions written to " + target)


def remove_dir(dirName):
    if os.path.isdir(dirName):
        shutil.rmtree(dirName)
        print("Removed directory:", dirName)


def run_cmd(cmd, msg="Failed to run command"):
    print("Running " + " ".join(map(str, cmd)))
    if subprocess.check_call(cmd):
        print(msg)
        exit(1)


def readData(workDir, bqrsFile):
    generatedJson = os.path.join(workDir, "out.json")
    print("Decoding BQRS to JSON.")
    run_cmd(
        [
            "codeql",
            "bqrs",
            "decode",
            bqrsFile,
            "--output",
            generatedJson,
            "--format=json",
        ],
        "Failed to decode BQRS.",
    )

    with open(generatedJson) as f:
        results = json.load(f)

    try:
        return results["#select"]["tuples"]
    except KeyError:
        print("Unexpected JSON output - no tuples found")
        exit(1)


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
