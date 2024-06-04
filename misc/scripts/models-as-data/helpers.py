import json
import os
import shutil
import subprocess

# Shared strings.
summaryModelPredicate = "summaryModel"
sinkModelPredicate = "sinkModel"
sourceModelPredicate = "sourceModel"
neutralModelPredicate = "neutralModel"
addsToTemplate = """  - addsTo:
      pack: {0}
      extensible: {1}
    data:
{2}"""

def remove_dir(dirName):
    if os.path.isdir(dirName):
        shutil.rmtree(dirName)
        print("Removed directory:", dirName)

def run_cmd(cmd, msg="Failed to run command"):
    print('Running ' + ' '.join(cmd))
    if subprocess.check_call(cmd):
        print(msg)
        exit(1)

def readData(workDir, bqrsFile):
    generatedJson = os.path.join(workDir, "out.json")
    print('Decoding BQRS to JSON.')
    run_cmd(['codeql', 'bqrs', 'decode', bqrsFile, '--output', generatedJson, '--format=json'], "Failed to decode BQRS.")

    with open(generatedJson) as f:
        results = json.load(f)

    try:
        return results['#select']['tuples']
    except KeyError:
        print('Unexpected JSON output - no tuples found')
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
