# Tool to generate Java stubs for qltests

import sys
import os
import subprocess
import json
import glob
import shlex
from shutil import copyfile

def print_usage(exit_code=1):
    print("Usage: python3 make_stubs.py testDir stubDir\n",
          "testDir: the directory containing the qltest to be stubbed. Should contain an `options0` file pointing to the jars to stub, and an `options1` file pointing to `stubdir`\n",
          "stubDir: the directory to output the generated stubs to")
    exit(exit_code)


if "--help" in sys.argv or "-h" in sys.argv:
    print_usage(0)

if len(sys.argv) != 3:
    print_usage()

testDir = sys.argv[1].rstrip("/")
stubDir = sys.argv[2].rstrip("/")


def check_dir_exists(path):
    if not os.path.isdir(path):
        print(path, "does not exist or is not a directory")
        exit(1)


def check_file_exists(path):
    if not os.path.isfile(path):
        print(path, "does not exist or is not a regular file")
        exit(1)

check_dir_exists(testDir)
check_dir_exists(stubDir)

optionsFile = os.path.join(testDir, "options")
options0File = os.path.join(testDir, "options0")
options1File = os.path.join(testDir, "options1")

check_file_exists(options0File)
check_file_exists(options1File)

# Does it contain a .ql file and a .java file?

foundJava = any(f.endswith(".java") for f in os.listdir(testDir))
foundQL = any(f.endswith(".ql") or f.endswith(".qlref") for f in os.listdir(testDir))

if not foundQL:
    print("Test directory does not contain .ql files. Please specify a working qltest directory.")
    exit(1)

if not foundJava:
    print("Test directory does not contain .java files. Please specify a working qltest directory.")
    exit(1)


javaQueries = os.path.abspath(os.path.dirname(sys.argv[0]))
outputBqrsFile = os.path.join(testDir, 'output.bqrs')
outputJsonFile = os.path.join(testDir, 'output.json')

dbDir = os.path.join(testDir, os.path.basename(testDir) + ".testproj")


def print_javac_output():
    logFiles = glob.glob(os.path.join(dbDir, "log", "javac-output*"))

    print("\nJavac output:\n")

    with open(logFile) as f:
        for line in f:
            b1 = line.find(']')
            b2 = line.find(']', b1+1)
            print(line[b2+2:], end="")

def run(cmd):
    """Runs the given command, returning the exit code (nonzero on failure)"""
    print('\nRunning: ' + shlex.join(cmd) + '\n')
    return subprocess.call(cmd)

print("Stubbing qltest in", testDir)

copyfile(options0File, optionsFile)

if run(['codeql', 'test', 'run', '--keep-databases', testDir]):
    print_javac_output()
    print("codeql test failed. Please fix up the test before proceeding.")
    exit(1)

if not os.path.isdir(dbDir):
    print("Expected database directory " + dbDir + " not found.")
    exit(1)

if run(['codeql', 'query', 'run', os.path.join(javaQueries, 'MinimalStubsFromSource.ql'), '--database', dbDir, '--output', outputBqrsFile]):
    print('Failed to run the query to generate the stubs.')
    exit(1)

if run(['codeql', 'bqrs', 'decode', outputBqrsFile, '--format=json', '--output', outputJsonFile]):
    print('Failed to convert ' + outputBqrsFile + ' to JSON.')
    exit(1)

with open(outputJsonFile) as f:
    results = json.load(f)

if not '#select' in results or not 'tuples' in results['#select']:
    print('Unexpected JSON output - no tuples found')
    exit(1)

for (typ, stub) in results['#select']['tuples']:
    stubFile = os.path.join(stubDir, typ.replace(".", "/") + ".java")
    os.makedirs(os.path.dirname(stubFile), exist_ok=True)
    with open(stubFile, "w") as f:
        f.write(stub)

print("Verifying stub correctness")

copyfile(options1File, optionsFile)

if run(['codeql', 'test', 'run', testDir]):
    print_javac_output()
    print('\nTest failed. You may need to fix up the generated stubs.')
    exit(1)

print("\nStub generation successful!")

exit(0)
