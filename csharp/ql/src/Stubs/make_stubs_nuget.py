import sys
import os
import helpers
import json
import shutil

print('Script to generate stub file from a nuget package')
print(' Usage: python ' + sys.argv[0] +
      ' NUGET_PACKAGE_NAME [VERSION=latest] [WORK_DIR=tempDir]')
print(' The script uses the dotnet cli, codeql cli, and dotnet format global tool')

if len(sys.argv) < 2:
    print("\nPlease supply a nuget package name.")
    exit(1)

thisScript = sys.argv[0]
thisDir = os.path.abspath(os.path.dirname(thisScript))
nuget = sys.argv[1]

# /input contains a dotnet project that's being extracted
workDir = os.path.abspath(helpers.get_argv(3, "tempDir"))
projectNameIn = "input"
projectDirIn = os.path.join(workDir, projectNameIn)

# /output contains the output of the stub generation
outputDirName = "output"
outputDir = os.path.join(workDir, outputDirName)

# /output/raw contains the bqrs result from the query, the json equivalent
rawOutputDirName = "raw"
rawOutputDir = os.path.join(outputDir, rawOutputDirName)
os.makedirs(rawOutputDir)

# /output/output contains a dotnet project with the generated stubs
projectNameOut = "output"
projectDirOut = os.path.join(outputDir, projectNameOut)

# /db contains the extracted QL DB
dbName = 'db'
dbDir = os.path.join(workDir, dbName)
outputName = "stub"
outputFile = os.path.join(projectDirOut, outputName + '.cs')
bqrsFile = os.path.join(rawOutputDir, outputName + '.bqrs')
jsonFile = os.path.join(rawOutputDir, outputName + '.json')
version = helpers.get_argv(2, "latest")

print("\n* Creating new input project")
helpers.run_cmd(['dotnet', 'new', 'classlib', "--language", "C#", '--name',
                 projectNameIn, '--output', projectDirIn])
helpers.remove_files(projectDirIn, '.cs')

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

print("\n* Running stubbing CodeQL query")
helpers.run_cmd(['codeql', 'query', 'run', os.path.join(
    thisDir, 'AllStubsFromReference.ql'), '--database', dbDir, '--output', bqrsFile])

helpers.run_cmd(['codeql', 'bqrs', 'decode', bqrsFile, '--output',
                 jsonFile, '--format=json'])

print("\n* Creating new raw output project")
rawSrcOutputDirName = 'src'
rawSrcOutputDir = os.path.join(rawOutputDir, rawSrcOutputDirName)
helpers.run_cmd(['dotnet', 'new', 'classlib', "--language", "C#",
                '--name', rawSrcOutputDirName, '--output', rawSrcOutputDir])
helpers.remove_files(rawSrcOutputDir, '.cs')

# load json from file
pathInfos = {}
with open(jsonFile) as json_data:
    data = json.load(json_data)
    for row in data['#select']['tuples']:
        pathInfos[row[3]] = os.path.join(rawSrcOutputDir, row[1] + '.cs')
        with open(pathInfos[row[3]], 'a') as f:
            f.write(row[4])

print("\n --> Generated stub files: " + rawSrcOutputDir)

print("\n* Formatting files")
helpers.run_cmd(['dotnet', 'format', rawSrcOutputDir])

print("\n --> Generated (formatted) stub files: " + rawSrcOutputDir)


print("\n* Processing project.assets.json to generate folder structure")
stubsDirName = 'stubs'
stubsDir = os.path.join(outputDir, stubsDirName)
os.makedirs(stubsDir)

stubFileName = '_stub.cs'

frameworksDirName = 'frameworks'
frameworksDir = os.path.join(stubsDir, frameworksDirName)

frameworks = set()
copiedFiles = set()

assetsJsonFile = os.path.join(projectDirIn, 'obj', 'project.assets.json')
with open(assetsJsonFile) as json_data:
    data = json.load(json_data)
    if len(data['targets']) > 1:
        print("ERROR: More than one target found in " + assetsJsonFile)
        exit(1)
    target = list(data['targets'].keys())[0]
    print("Found target: " + target)
    for package in data['targets'][target].keys():
        parts = package.split('/')
        name = parts[0]
        version = parts[1]
        packageDir = os.path.join(stubsDir, name, version)
        if not os.path.exists(packageDir):
            os.makedirs(packageDir)
        print('  * Processing package: ' + name + '/' + version)
        with open(os.path.join(packageDir, stubFileName), 'a') as f:
            with open(os.path.join(packageDir, name + '.csproj'), 'a') as pf:

                pf.write('<Project Sdk="Microsoft.NET.Sdk">\n')
                pf.write('  <PropertyGroup>\n')
                pf.write('    <TargetFramework>net5.0</TargetFramework>\n')
                pf.write('    <AllowUnsafeBlocks>true</AllowUnsafeBlocks>\n')
                pf.write('    <OutputPath>bin\</OutputPath>\n')
                pf.write(
                    '    <AppendTargetFrameworkToOutputPath>false</AppendTargetFrameworkToOutputPath>\n')
                pf.write('  </PropertyGroup>\n\n')
                pf.write('  <ItemGroup>\n')

                f.write('// Stub for ' + name + ' version ' + version + '\n\n')

                dlls = set()
                if 'compile' in data['targets'][target][package]:
                    for dll in data['targets'][target][package]['compile']:
                        dlls.add(
                            (name + '/' + version + '/' + dll).lower())
                if 'runtime' in data['targets'][target][package]:
                    for dll in data['targets'][target][package]['runtime']:
                        dlls.add((name + '/' + version + '/' + dll).lower())

                for pathInfo in pathInfos:
                    for dll in dlls:
                        if pathInfo.lower().endswith(dll):
                            copiedFiles.add(pathInfo)
                            shutil.copy2(pathInfos[pathInfo], packageDir)
                            f.write('// semmle-extractor-options: ' +
                                    os.path.basename(pathInfos[pathInfo]) + '\n')

                if 'dependencies' in data['targets'][target][package]:
                    for dependency in data['targets'][target][package]['dependencies'].keys():
                        depVersion = data['targets'][target][package]['dependencies'][dependency]
                        f.write('// semmle-extractor-options: ../../' +
                                dependency + '/' + depVersion + '/' + stubFileName + '\n')
                        pf.write('    <ProjectReference Include="../../' +
                                 dependency + '/' + depVersion + '/' + dependency + '.csproj" />\n')

                if 'frameworkReferences' in data['targets'][target][package]:
                    if not os.path.exists(frameworksDir):
                        os.makedirs(frameworksDir)
                    for framework in data['targets'][target][package]['frameworkReferences']:
                        frameworks.add(framework)
                        frameworkDir = os.path.join(
                            frameworksDir, framework)
                        if not os.path.exists(frameworkDir):
                            os.makedirs(frameworkDir)
                        f.write('// semmle-extractor-options: ../../' + frameworksDirName + '/' +
                                framework + '/' + stubFileName + '\n')
                        pf.write('    <ProjectReference Include="../../' +
                                 frameworksDirName + '/' + framework + '/' + framework + '.csproj" />\n')

                pf.write('  </ItemGroup>\n')
                pf.write('</Project>\n')

for framework in frameworks:
    with open(os.path.join(frameworksDir, framework, stubFileName), 'a') as f:
        with open(os.path.join(frameworksDir, framework, framework + '.csproj'), 'a') as pf:

            pf.write('<Project Sdk="Microsoft.NET.Sdk">\n')
            pf.write('  <PropertyGroup>\n')
            pf.write('    <TargetFramework>net5.0</TargetFramework>\n')
            pf.write('    <AllowUnsafeBlocks>true</AllowUnsafeBlocks>\n')
            pf.write('    <OutputPath>bin\</OutputPath>\n')
            pf.write(
                '    <AppendTargetFrameworkToOutputPath>false</AppendTargetFrameworkToOutputPath>\n')
            pf.write('  </PropertyGroup>\n')
            pf.write('</Project>\n')

            f.write('// Stub for ' + framework + '\n\n')

            for pathInfo in pathInfos:
                if 'packs/' + framework.lower() in pathInfo.lower():
                    copiedFiles.add(pathInfo)
                    shutil.copy2(pathInfos[pathInfo], os.path.join(
                        frameworksDir, framework))
                    f.write('// semmle-extractor-options: ' +
                            os.path.basename(pathInfos[pathInfo]) + '\n')

for pathInfo in pathInfos:
    if pathInfo not in copiedFiles:
        print('Not copied to nuget or framework folder: ' + pathInfo)
        othersDir = os.path.join(stubsDir, 'others')
        if not os.path.exists(othersDir):
            os.makedirs(othersDir)
        shutil.copy2(pathInfos[pathInfo], othersDir)

print("\n --> Generated structured stub files: " + stubsDir)

print("\n* Building raw output project")
helpers.run_cmd(['dotnet', 'build', '/t:rebuild', '/p:AllowUnsafeBlocks=true', '/p:WarningLevel=0', rawSrcOutputDir],
                'ERR: Build failed. Script failed to generate a stub that builds. Please touch up manually the stubs.')

print("\n --> Generated structured stub files: " + stubsDir)

exit(0)
