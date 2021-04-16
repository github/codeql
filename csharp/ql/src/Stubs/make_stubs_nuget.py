import sys
import os
import helpers

print('Script to generate stub file from a nuget package')
print(' Usage: python ' + sys.argv[0] +
      ' NUGET_PACKAGE_NAME [VERSION=latest] [WORK_DIR=tempDir] [OUTPUT_NAME=stub]')
print(' The script uses the dotnet cli, codeql cli, and dotnet format global tool')

if len(sys.argv) < 2:
    print("\nPlease supply a nuget package name.")
    exit(1)

thisScript = sys.argv[0]
thisDir = os.path.abspath(os.path.dirname(thisScript))
nuget = sys.argv[1]

workDir = os.path.abspath(helpers.get_argv(3, "tempDir"))
projectNameIn = "input"
projectDirIn = os.path.join(workDir, projectNameIn)

projectNameOut = "output"
projectDirOut = os.path.join(workDir, projectNameOut)
dbName = 'db'
dbDir = os.path.join(workDir, dbName)
outputName = helpers.get_argv(4, "stub")
outputFile = os.path.join(projectDirOut, outputName + '.cs')
bqrsFile = os.path.join(projectDirOut, outputName + '.bqrs')
version = helpers.get_argv(2, "latest")

print("\n* Creating new input project")
helpers.run_cmd(['dotnet', 'new', 'classlib', "--language", "C#", '--name',
                 projectNameIn, '--output', projectDirIn])

print("\n* Adding reference to package: " + nuget)
cmd = ['dotnet', 'add', projectDirIn, 'package', nuget]
if (version != "latest"):
    cmd.append('--version')
    cmd.append(version)
helpers.run_cmd(cmd)

print("\n* Creating DB")
helpers.run_cmd(['codeql', 'database', 'create', dbDir, '--language=csharp',
                 '--command', 'dotnet build /t:rebuild ' + projectDirIn])

if not os.path.isdir(dbDir):
    print("Expected database directory " + dbDir + " not found.")
    exit(1)

print("\n* Creating new output project")
helpers.run_cmd(['dotnet', 'new', 'classlib', "--language", "C#", '--name',
                 projectNameOut, '--output', projectDirOut])

print("\n* Running stubbing CodeQL query")
helpers.run_cmd(['codeql', 'query', 'run', os.path.join(
    thisDir, 'AllStubsFromReference.ql'), '--database', dbDir, '--output', bqrsFile])

helpers.run_cmd(['codeql', 'bqrs', 'decode', bqrsFile, '--output',
                 outputFile, '--format=text', '--no-titles'])

helpers.trim_output_file(outputFile)

print("\n --> Generated output file: " + outputFile)

print("\n* Formatting file")
helpers.run_cmd(['dotnet', 'format', projectDirOut,
                '--include', outputName + '.cs'])

print("\n* Building output project")
helpers.run_cmd(['dotnet', 'build', '/t:rebuild', projectDirOut],
                'ERR: Build failed. Script failed to generate a stub that builds')

print("\n --> Generated output file: " + outputFile)
exit(0)
