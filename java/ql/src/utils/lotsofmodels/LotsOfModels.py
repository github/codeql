#!/usr/bin/python3

import json
import os
import os.path
import shlex
import subprocess
import sys
import tempfile

# Add Model as Data script directory to sys.path.
gitroot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
madpath = os.path.join(gitroot, "misc/scripts/models-as-data/")
sys.path.append(madpath)

import helpers

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

def parseData(data):
    rows = { }
    for row in data:
        d = map(quote_if_needed, row)
        insert_update(rows, row[0], "      - [" + ', '.join(d) + ']\n')

    return rows

class Generator:
    def __init__(self, language, n):
        self.language = language
        self.codeQlRoot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
        self.extDir = os.path.join(self.codeQlRoot, f"{self.language}/ql/lib/ext/")
        self.modelFileExtension = ".model.yml"
        self.packagecount = n


    def makeData(self, f, package):
        n = 30
        for a in range(n):
            for b in range(n):
                for c in range(n):
                    for k in ["value", "taint"]:
                        for p in ["manual", "generated"]:
                            f.write(f"""      - ["{package}", "myClass{str(a)}", False, "myName{str(b)}", "(Object)", "", "Argument[{str(c)}]", "ReturnValue", "{k}", "{p}"]""")
                            f.write("\n")


    def run(self):
        for i in range(self.packagecount):
            package = f"package{i}"
            with open(self.extDir + "/" + package + self.modelFileExtension, "w") as f:
                f.write("extensions:\n")
                f.write("  - addsTo:\n")
                f.write("      pack: codeql/java-all\n")
                f.write("      extensible: summaryModel\n")
                f.write("    data:\n")
                self.makeData(f, package)


## Make Lots of Models
language = "java"
Generator(language, int(sys.argv[1])).run()