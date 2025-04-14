import sys
import os
import subprocess
import json
import shutil
import re

def run_cmd(cmd, msg="Failed to run command"):
    print('Running ' + ' '.join(cmd))
    if subprocess.check_call(cmd):
        print(msg)
        exit(1)


def run_cmd_cwd(cmd, cwd, msg="Failed to run command"):
    print('Change working directory to: ' + cwd)
    print('Running ' + ' '.join(cmd))
    if subprocess.check_call(cmd, cwd=cwd):
        print(msg)
        exit(1)


def get_argv(index, default):
    if len(sys.argv) > index:
        return sys.argv[index]
    return default


def trim_output_file(file):
    # Remove the leading and trailing bytes from the file
    length = os.stat(file).st_size
    if length < 20:
        contents = b''
    else:
        f = open(file, "rb")
        try:
            pre = f.read(2)
            print("Start characters in file skipped.", pre)
            contents = f.read(length - 5)
            post = f.read(3)
            print("End characters in file skipped.", post)
        finally:
            f.close()

    f = open(file, "wb")
    f.write(contents)
    f.close()


# remove all files with extension
def remove_files(path, ext):
    for file in os.listdir(path):
        if file.endswith(ext):
            os.remove(os.path.join(path, file))

def write_csproj_prefix(ioWrapper):
    ioWrapper.write('<Project Sdk="Microsoft.NET.Sdk">\n')
    ioWrapper.write('  <PropertyGroup>\n')
    ioWrapper.write('    <TargetFramework>net9.0</TargetFramework>\n')
    ioWrapper.write('    <AllowUnsafeBlocks>true</AllowUnsafeBlocks>\n')
    ioWrapper.write('    <OutputPath>bin\</OutputPath>\n')
    ioWrapper.write(
        '    <AppendTargetFrameworkToOutputPath>false</AppendTargetFrameworkToOutputPath>\n')
    ioWrapper.write('  </PropertyGroup>\n\n')

class Generator:
    def __init__(self, thisScript, relativeWorkDir, template):
        # /input contains a dotnet project that's being extracted
        self.workDir = os.path.abspath(relativeWorkDir)
        os.makedirs(self.workDir)
        self.thisDir = os.path.abspath(os.path.dirname(thisScript))
        self.projectNameIn = "input"
        self.projectDirIn = os.path.join(self.workDir, self.projectNameIn)
        self.template = template
        print("\n* Creating new input project")
        self.run_cmd(['dotnet', 'new', self.template, "-f", "net9.0", "--language", "C#", '--name',
                         self.projectNameIn, '--output', self.projectDirIn])
        remove_files(self.projectDirIn, '.cs')

        # Clear possibly inherited Directory.Build.props and Directory.Build.targets:
        with open(os.path.join(self.workDir, 'Directory.Build.props'), 'w') as f:
            f.write('<Project>\n')
            f.write('</Project>\n')
        with open(os.path.join(self.workDir, 'Directory.Build.targets'), 'w') as f:
            f.write('<Project>\n')
            f.write('</Project>\n')

    def run_cmd(self, cmd, msg="Failed to run command"):
        run_cmd_cwd(cmd, self.workDir, msg)

    def add_nuget(self, nuget, version="latest"):
        print("\n* Adding reference to package: " + nuget)
        cmd = ['dotnet', 'add', self.projectDirIn, 'package', nuget]
        if (version != "latest"):
            cmd.append('--version')
            cmd.append(version)
        self.run_cmd(cmd)

    def make_stubs(self):
        # /output contains the output of the stub generation
        outputDirName = "output"
        outputDir = os.path.join(self.workDir, outputDirName)

        # /output/raw contains the bqrs result from the query, the json equivalent
        rawOutputDirName = "raw"
        rawOutputDir = os.path.join(outputDir, rawOutputDirName)
        os.makedirs(rawOutputDir)

        # /output/output contains a dotnet project with the generated stubs
        projectNameOut = "output"
        projectDirOut = os.path.join(outputDir, projectNameOut)

        # /db contains the extracted QL DB
        dbName = 'db'
        dbDir = os.path.join(self.workDir, dbName)
        outputName = "stub"
        outputFile = os.path.join(projectDirOut, outputName + '.cs')
        bqrsFile = os.path.join(rawOutputDir, outputName + '.bqrs')
        jsonFile = os.path.join(rawOutputDir, outputName + '.json')

        sdk_version = '9.0.100'
        print("\n* Creating new global.json file and setting SDK to " + sdk_version)
        self.run_cmd(['dotnet', 'new', 'globaljson', '--force', '--sdk-version', sdk_version, '--output', self.workDir])

        print("\n* Running stub generator")
        run_cmd_cwd(['dotnet', 'run', '--project', self.thisDir + '/../../extractor/Semmle.Extraction.CSharp.DependencyStubGenerator/Semmle.Extraction.CSharp.DependencyStubGenerator.csproj'], self.projectDirIn)

        print("\n* Creating new raw output project")
        rawSrcOutputDirName = 'src'
        rawSrcOutputDir = os.path.join(rawOutputDir, rawSrcOutputDirName)
        self.run_cmd(['dotnet', 'new', self.template, "--language", "C#",
                        '--name', rawSrcOutputDirName, '--output', rawSrcOutputDir])
        remove_files(rawSrcOutputDir, '.cs')

        # copy each file from projectDirIn to rawSrcOutputDir
        pathInfos = {}
        codeqlStubsDir = os.path.join(self.projectDirIn, 'codeql_csharp_stubs')
        for root, dirs, files in os.walk(codeqlStubsDir):
            for file in files:
                if file.endswith('.cs'):
                    path = os.path.join(root, file)
                    relPath, _ = os.path.splitext(os.path.relpath(path, codeqlStubsDir))
                    origDllPath = "/" + relPath + ".dll"
                    pathInfos[origDllPath] = os.path.join(rawSrcOutputDir, file)
                    shutil.copy2(path, rawSrcOutputDir)

        print("\n --> Generated stub files: " + rawSrcOutputDir)

        print("\n* Formatting files")
        self.run_cmd(['dotnet', 'format', 'whitespace', rawSrcOutputDir])

        print("\n --> Generated (formatted) stub files: " + rawSrcOutputDir)

        print("\n* Processing project.assets.json to generate folder structure")
        stubsDirName = 'stubs'
        stubsDir = os.path.join(outputDir, stubsDirName)
        os.makedirs(stubsDir)

        frameworksDirName = '_frameworks'
        frameworksDir = os.path.join(stubsDir, frameworksDirName)

        frameworks = set()
        copiedFiles = set()

        assetsJsonFile = os.path.join(self.projectDirIn, 'obj', 'project.assets.json')
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
                with open(os.path.join(packageDir, name + '.csproj'), 'a') as pf:

                    write_csproj_prefix(pf)
                    pf.write('  <ItemGroup>\n')

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

                    if 'dependencies' in data['targets'][target][package]:
                        for dependency in data['targets'][target][package]['dependencies'].keys():
                            depString = data['targets'][target][package]['dependencies'][dependency]
                            depVersion = re.search("(\d+\.\d+\.\d+(-[a-z]+)?)", depString).group(0)
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
                            pf.write('    <ProjectReference Include="../../' +
                                     frameworksDirName + '/' + framework + '/' + framework + '.csproj" />\n')

                    pf.write('    <ProjectReference Include="../../' +
                             frameworksDirName + '/Microsoft.NETCore.App/Microsoft.NETCore.App.csproj" />\n')

                    pf.write('  </ItemGroup>\n')
                    pf.write('</Project>\n')

        # Processing references frameworks
        for framework in frameworks:
            with open(os.path.join(frameworksDir, framework, framework + '.csproj'), 'a') as pf:

                write_csproj_prefix(pf)
                pf.write('  <ItemGroup>\n')
                pf.write(
                    '    <ProjectReference Include="../Microsoft.NETCore.App/Microsoft.NETCore.App.csproj" />\n')
                pf.write('  </ItemGroup>\n')
                pf.write('</Project>\n')

                for pathInfo in pathInfos:
                    if framework.lower() + '.ref' in pathInfo.lower():
                        copiedFiles.add(pathInfo)
                        shutil.copy2(pathInfos[pathInfo], os.path.join(
                            frameworksDir, framework))

        # Processing assemblies in  Microsoft.NETCore.App.Ref
        frameworkDir = os.path.join(frameworksDir, 'Microsoft.NETCore.App')
        if not os.path.exists(frameworkDir):
            os.makedirs(frameworkDir)
        with open(os.path.join(frameworksDir, 'Microsoft.NETCore.App', 'Microsoft.NETCore.App.csproj'), 'a') as pf:
            write_csproj_prefix(pf)
            pf.write('</Project>\n')

            for pathInfo in pathInfos:
                if 'microsoft.netcore.app.ref/' in pathInfo.lower():
                    copiedFiles.add(pathInfo)
                    shutil.copy2(pathInfos[pathInfo], frameworkDir)

        for pathInfo in pathInfos:
            if pathInfo not in copiedFiles:
                print('Not copied to nuget or framework folder: ' + pathInfo)
                othersDir = os.path.join(stubsDir, 'others')
                if not os.path.exists(othersDir):
                    os.makedirs(othersDir)
                shutil.copy2(pathInfos[pathInfo], othersDir)

        print("\n --> Generated structured stub files: " + stubsDir)
