import sys
import os
import helpers


print('Script to generate stub.cs file from a nuget package')
print('Usage: python ' + sys.argv[0] +
      ' NUGET_PACKAGE_NAME [VERSION=latest] [WORK_DIR=tempDir] [OUTPUT_NAME=stub]')

if len(sys.argv) < 2:
    print("\nPlease supply a nuget package name.")
    exit(1)

thisScript = sys.argv[0]
thisDir = os.path.abspath(os.path.dirname(thisScript))
nuget = sys.argv[1]

workDir = os.path.abspath(helpers.get_argv(3, "tempDir"))
projectName = "proj"
projectDir = os.path.join(workDir, projectName)
dbName = 'db'
dbDir = os.path.join(workDir, dbName)
outputName = helpers.get_argv(4, "stub")
outputFile = os.path.join(workDir, outputName + '.cs')
bqrsFile = os.path.join(workDir, outputName + '.bqrs')
version = helpers.get_argv(2, "latest")

print("\nCreating new project")
helpers.run_cmd(['dotnet', 'new', 'classlib', "--language", "C#", '--name',
                 projectName, '--output', projectDir])

print("\nAdding reference")
cmd = ['dotnet', 'add', projectDir, 'package', nuget]
if (version != "latest"):
    cmd.append('--version')
    cmd.append(version)
helpers.run_cmd(cmd)

print("\nCreating DB")
helpers.run_cmd(['codeql', 'database', 'create', dbDir, '--language=csharp',
                 '--command', 'dotnet build /t:rebuild ' + projectDir])

if not os.path.isdir(dbDir):
    print("Expected database directory " + dbDir + " not found.")
    exit(1)

print("\nRunning query")
helpers.run_cmd(['codeql', 'query', 'run', os.path.join(
    thisDir, 'AllStubsFromReference.ql'), '--database', dbDir, '--output', bqrsFile])

helpers.run_cmd(['codeql', 'bqrs', 'decode', bqrsFile, '--output',
                 outputFile, '--format=text', '--no-titles'])

helpers.trim_output_file(outputFile)

print("\nOutput: " + outputFile)
exit(0)
