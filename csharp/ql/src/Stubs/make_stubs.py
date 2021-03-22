# Tool to generate 'stub.cs' files inside C# qltest projects.
# The purpose of this is to stub out assemblies from the qltest case
# so that the test is self-contained and will still run without them.
#
# To do this, it
# 1. Performs a regular qltest to generate a snapshot
# 2. Runs a QL query on the snapshot to find out which symbols are needed,
#    then uses QL to generate a string of C# code.
# 3. Re-runs the test to ensure that it still compiles and passes.

import sys
import os
import subprocess

print('Script to generate stub.cs files for C# qltest projects')

if len(sys.argv) < 2:
    print("Please supply a qltest directory.")
    exit(1)

testDir = sys.argv[1]

if not os.path.isdir(testDir):
    print("Directory", testDir, "does not exist")
    exit(1)

# Does it contain a .ql file and a .cs file?

foundCS = False
foundQL = False

for file in os.listdir(testDir):
    if file.endswith(".cs"):
        foundCS = True
    if file.endswith(".ql") or file.endswith(".qlref"):
        foundQL = True

if not foundQL:
    print("Test directory does not contain .ql files. Please specify a working qltest directory.")
    exit(1)

if not foundCS:
    print("Test directory does not contain .cs files. Please specify a working qltest directory.")
    exit(1)

csharpQueries = os.path.abspath(os.path.dirname(sys.argv[0]))
outputFile = os.path.join(testDir, 'stubs.cs')

print("Stubbing qltest in", testDir)

if os.path.isfile(outputFile):
    os.remove(outputFile)  # It would interfere with the test.
    print("Removed previous", outputFile)

cmd = ['codeql', 'test', 'run', '--keep-databases', testDir]
print('Running ' + ' '.join(cmd))
if subprocess.check_call(cmd):
    print("codeql test failed. Please fix up the test before proceeding.")
    exit(1)

dbDir = os.path.join(testDir, os.path.basename(testDir) + ".testproj")

if not os.path.isdir(dbDir):
    print("Expected database directory " + dbDir + " not found.")
    exit(1)

cmd = ['codeql', 'query', 'run', os.path.join(
    csharpQueries, 'MinimalStubsFromSource.ql'), '--database', dbDir, '--output', outputFile]
print('Running ' + ' '.join(cmd))
if subprocess.check_call(cmd):
    print('Failed to run the query to generate output file.')
    exit(1)

# Remove the leading and trailing bytes from the file
length = os.stat(outputFile).st_size
if length < 20:
    contents = b''
else:
    f = open(outputFile, "rb")
    try:
        countTillSlash = 0
        foundSlash = False
        slash = f.read(1)
        while slash != b'':
            if slash == b'/':
                foundSlash = True
                break
            countTillSlash += 1
            slash = f.read(1)

        if not foundSlash:
            countTillSlash = 0

        f.seek(0)
        quote = f.read(countTillSlash)
        print("Start characters in file skipped.", quote)
        post = b'\x0e\x01\x08#select\x01\x01\x00s\x00'
        contents = f.read(length - len(post) - countTillSlash)
        quote = f.read(len(post))
        if quote != post:
            print("Unexpected end character in file.", quote)
    finally:
        f.close()

f = open(outputFile, "wb")
f.write(contents)
f.close()

cmd = ['codeql', 'test', 'run', testDir]
print('Running ' + ' '.join(cmd))
if subprocess.check_call(cmd):
    print('\nTest failed. You may need to fix up', outputFile)
    print('It may help to view', outputFile, ' in Visual Studio')
    print("Next steps:")
    print('1. Look at the compilation errors, and fix up',
          outputFile, 'so that the test compiles')
    print('2. Re-run codeql test run "' + testDir + '"')
    print('3. git add "' + outputFile + '"')
    exit(1)

print("\nStub generation successful! Next steps:")
print('1. Edit "semmle-extractor-options" in the .cs files to remove unused references')
print('2. Re-run odasa qltest --optimize "' + testDir + '"')
print('3. git add "' + outputFile + '"')
print('4. Commit your changes.')

exit(0)
