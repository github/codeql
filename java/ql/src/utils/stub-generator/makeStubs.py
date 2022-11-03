#!/usr/bin/python3

# Tool to generate Java stubs for qltests

import sys
import os
import subprocess
import json
import glob
import shlex
import shutil
import tempfile
from shutil import copyfile


def print_usage(exit_code=1):
    print("Usage: makeStubs.py testDir stubDir [pom.xml]\n",
          "testDir: the directory containing the qltest to be stubbed.\n"
          "    Should contain an 'options' file pointing to 'stubDir'.\n"
          "    This file should be in the same format as a normal 'options' file.\n",
          "stubDir: the directory to output the generated stubs to\n",
          "pom.xml: a 'pom.xml' file that can be used to build the project\n",
          "    If the test can be extracted without a 'pom.xml', this argument can be ommitted.")
    exit(exit_code)


if "--help" in sys.argv or "-h" in sys.argv:
    print_usage(0)

if len(sys.argv) not in [3, 4]:
    print_usage()

testDir = os.path.normpath(sys.argv[1])
stubDir = os.path.normpath(sys.argv[2])


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

check_file_exists(optionsFile)

# Does it contain a .ql file and a .java file?

foundJava = any(f.endswith(".java") for f in os.listdir(testDir))
foundQL = any(f.endswith(".ql") or f.endswith(".qlref")
              for f in os.listdir(testDir))

if not foundQL:
    print("Test directory does not contain .ql files. Please specify a working qltest directory.")
    exit(1)

if not foundJava:
    print("Test directory does not contain .java files. Please specify a working qltest directory.")
    exit(1)


workDir = tempfile.TemporaryDirectory().name

print("Created temporary directory '%s'" % workDir)

javaQueries = os.path.abspath(os.path.dirname(sys.argv[0]))
outputBqrsFile = os.path.join(workDir, 'output.bqrs')
outputJsonFile = os.path.join(workDir, 'output.json')

# Make a database that touches all types whose methods we want to test:
print("Creating Maven project")
projectDir = os.path.join(workDir, "mavenProject")

if len(sys.argv) == 4:
    projectTestPkgDir = os.path.join(projectDir, "src", "main", "java", "test")
    shutil.copytree(testDir, projectTestPkgDir,
                    ignore=shutil.ignore_patterns('*.testproj'))

    try:
        shutil.copyfile(sys.argv[3], os.path.join(projectDir, "pom.xml"))
    except Exception as e:
        print("Failed to read project POM %s: %s" %
              (sys.argv[2], e), file=sys.stderr)
        sys.exit(1)
else:
    # if `pom.xml` is omitted, simply copy the test directory to `projectDir`
    shutil.copytree(testDir, projectDir,
                    ignore=shutil.ignore_patterns('*.testproj'))

dbDir = os.path.join(workDir, "db")


def print_javac_output():
    logFiles = glob.glob(os.path.join(dbDir, "log", "javac-output*"))

    if not(logFiles):
        print("\nNo javac output found.")
    else:
        logFile = logFiles[0]
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

if run(['codeql', 'database', 'create', '--language=java', '--source-root='+projectDir, dbDir]):
    print_javac_output()
    print("codeql database create failed. Please fix up the test before proceeding.")
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

try:
    results['#select']['tuples']
    results['noGeneratedStubs']['tuples']
    results['multipleGeneratedStubs']['tuples']
except KeyError:
    print('Unexpected JSON output - no tuples found')
    exit(1)

for (typ,) in results['noGeneratedStubs']['tuples']:
    print(f"WARNING: No stubs generated for {typ}. This is probably a bug.")

for (typ,) in results['multipleGeneratedStubs']['tuples']:
    print(
        f"WARNING: Multiple stubs generated for {typ}. This is probably a bug. One will be chosen arbitrarily.")

for (typ, stub) in results['#select']['tuples']:
    stubFile = os.path.join(stubDir, *typ.split(".")) + ".java"
    os.makedirs(os.path.dirname(stubFile), exist_ok=True)
    with open(stubFile, "w") as f:
        f.write(stub)

print("Verifying stub correctness")

if run(['codeql', 'test', 'run', testDir]):
    print_javac_output()
    print('\nTest failed. You may need to fix up the generated stubs.')
    exit(1)

os.rmdir(workDir)

print("\nStub generation successful!")

exit(0)
