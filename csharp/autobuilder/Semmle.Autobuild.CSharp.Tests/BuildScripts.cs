using Xunit;
using Semmle.Autobuild.Shared;
using System.Collections.Generic;
using System;
using System.Linq;
using Microsoft.Build.Construction;
using System.Xml;

namespace Semmle.Autobuild.CSharp.Tests
{
    /// <summary>
    /// Test class to script Autobuilder scenarios.
    /// For most methods, it uses two fields:
    /// - an IList to capture the the arguments passed to it
    /// - an IDictionary of possible return values.
    /// </summary>
    class TestActions : IBuildActions
    {
        /// <summary>
        /// List of strings passed to FileDelete.
        /// </summary>
        public readonly IList<string> FileDeleteIn = new List<string>();

        void IBuildActions.FileDelete(string file)
        {
            FileDeleteIn.Add(file);
        }

        public readonly IList<string> FileExistsIn = new List<string>();
        public readonly IDictionary<string, bool> FileExists = new Dictionary<string, bool>();

        bool IBuildActions.FileExists(string file)
        {
            FileExistsIn.Add(file);
            if (FileExists.TryGetValue(file, out var ret))
                return ret;
            if (FileExists.TryGetValue(System.IO.Path.GetFileName(file), out ret))
                return ret;
            throw new ArgumentException("Missing FileExists " + file);
        }

        public readonly IList<string> RunProcessIn = new List<string>();
        public readonly IDictionary<string, int> RunProcess = new Dictionary<string, int>();
        public readonly IDictionary<string, string> RunProcessOut = new Dictionary<string, string>();
        public readonly IDictionary<string, string> RunProcessWorkingDirectory = new Dictionary<string, string>();

        int IBuildActions.RunProcess(string cmd, string args, string? workingDirectory, IDictionary<string, string>? env, out IList<string> stdOut)
        {
            var pattern = cmd + " " + args;
            RunProcessIn.Add(pattern);
            if (RunProcessOut.TryGetValue(pattern, out var str))
                stdOut = str.Split("\n");
            else
                throw new ArgumentException("Missing RunProcessOut " + pattern);
            RunProcessWorkingDirectory.TryGetValue(pattern, out var wd);
            if (wd != workingDirectory)
                throw new ArgumentException("Missing RunProcessWorkingDirectory " + pattern);
            if (RunProcess.TryGetValue(pattern, out var ret))
                return ret;
            throw new ArgumentException("Missing RunProcess " + pattern);
        }

        int IBuildActions.RunProcess(string cmd, string args, string? workingDirectory, IDictionary<string, string>? env)
        {
            var pattern = cmd + " " + args;
            RunProcessIn.Add(pattern);
            RunProcessWorkingDirectory.TryGetValue(pattern, out var wd);
            if (wd != workingDirectory)
                throw new ArgumentException("Missing RunProcessWorkingDirectory " + pattern);
            if (RunProcess.TryGetValue(pattern, out var ret))
                return ret;
            throw new ArgumentException("Missing RunProcess " + pattern);
        }

        public readonly IList<string> DirectoryDeleteIn = new List<string>();

        void IBuildActions.DirectoryDelete(string dir, bool recursive)
        {
            DirectoryDeleteIn.Add(dir);
        }

        public readonly IDictionary<string, bool> DirectoryExists = new Dictionary<string, bool>();

        bool IBuildActions.DirectoryExists(string dir)
        {
            if (DirectoryExists.TryGetValue(dir, out var ret))
                return ret;
            throw new ArgumentException("Missing DirectoryExists " + dir);
        }

        public readonly IDictionary<string, string?> GetEnvironmentVariable = new Dictionary<string, string?>();

        string? IBuildActions.GetEnvironmentVariable(string name)
        {
            if (GetEnvironmentVariable.TryGetValue(name, out var ret))
                return ret;
            throw new ArgumentException("Missing GetEnvironmentVariable " + name);
        }

        public string GetCurrentDirectory = "";

        string IBuildActions.GetCurrentDirectory()
        {
            return GetCurrentDirectory;
        }

        public readonly IDictionary<string, string> EnumerateFiles = new Dictionary<string, string>();

        IEnumerable<string> IBuildActions.EnumerateFiles(string dir)
        {
            if (EnumerateFiles.TryGetValue(dir, out var str))
                return str.Split("\n");
            throw new ArgumentException("Missing EnumerateFiles " + dir);
        }

        public readonly IDictionary<string, string> EnumerateDirectories = new Dictionary<string, string>();

        IEnumerable<string> IBuildActions.EnumerateDirectories(string dir)
        {
            if (EnumerateDirectories.TryGetValue(dir, out var str))
                return string.IsNullOrEmpty(str) ? Enumerable.Empty<string>() : str.Split("\n");
            throw new ArgumentException("Missing EnumerateDirectories " + dir);
        }

        public bool IsWindows;

        bool IBuildActions.IsWindows() => IsWindows;

        string IBuildActions.PathCombine(params string[] parts)
        {
            return string.Join(IsWindows ? '\\' : '/', parts.Where(p => !string.IsNullOrWhiteSpace(p)));
        }

        string IBuildActions.GetFullPath(string path) => path;

        void IBuildActions.WriteAllText(string filename, string contents)
        {
        }

        public readonly IDictionary<string, XmlDocument> LoadXml = new Dictionary<string, XmlDocument>();

        XmlDocument IBuildActions.LoadXml(string filename)
        {
            if (LoadXml.TryGetValue(filename, out var xml))
                return xml;
            throw new ArgumentException("Missing LoadXml " + filename);
        }

        public string EnvironmentExpandEnvironmentVariables(string s)
        {
            foreach (var kvp in GetEnvironmentVariable)
                s = s.Replace($"%{kvp.Key}%", kvp.Value);
            return s;
        }
    }

    /// <summary>
    /// A fake solution to build.
    /// </summary>
    class TestSolution : ISolution
    {
        public IEnumerable<SolutionConfigurationInSolution> Configurations => throw new NotImplementedException();

        public string DefaultConfigurationName => "Release";

        public string DefaultPlatformName => "x86";

        public string FullPath { get; set; }

        public Version ToolsVersion => new Version("14.0");

        public IEnumerable<IProjectOrSolution> IncludedProjects => throw new NotImplementedException();

        public TestSolution(string path)
        {
            FullPath = path;
        }
    }

    public class BuildScriptTests
    {
        readonly TestActions Actions = new TestActions();

        // Records the arguments passed to StartCallback.
        readonly IList<string> StartCallbackIn = new List<string>();

        void StartCallback(string s, bool silent)
        {
            StartCallbackIn.Add(s);
        }

        // Records the arguments passed to EndCallback
        readonly IList<string> EndCallbackIn = new List<string>();
        readonly IList<int> EndCallbackReturn = new List<int>();

        void EndCallback(int ret, string s, bool silent)
        {
            EndCallbackReturn.Add(ret);
            EndCallbackIn.Add(s);
        }

        [Fact]
        public void TestBuildCommand()
        {
            var cmd = BuildScript.Create("abc", "def ghi", false, null, null);

            Actions.RunProcess["abc def ghi"] = 1;
            cmd.Run(Actions, StartCallback, EndCallback);
            Assert.Equal("abc def ghi", Actions.RunProcessIn[0]);
            Assert.Equal("abc def ghi", StartCallbackIn[0]);
            Assert.Equal("", EndCallbackIn[0]);
            Assert.Equal(1, EndCallbackReturn[0]);
        }

        [Fact]
        public void TestAnd1()
        {
            var cmd = BuildScript.Create("abc", "def ghi", false, null, null) & BuildScript.Create("odasa", null, false, null, null);

            Actions.RunProcess["abc def ghi"] = 1;
            cmd.Run(Actions, StartCallback, EndCallback);

            Assert.Equal("abc def ghi", Actions.RunProcessIn[0]);
            Assert.Equal("abc def ghi", StartCallbackIn[0]);
            Assert.Equal("", EndCallbackIn[0]);
            Assert.Equal(1, EndCallbackReturn[0]);
        }

        [Fact]
        public void TestAnd2()
        {
            var cmd = BuildScript.Create("odasa", null, false, null, null) & BuildScript.Create("abc", "def ghi", false, null, null);

            Actions.RunProcess["abc def ghi"] = 1;
            Actions.RunProcess["odasa "] = 0;
            cmd.Run(Actions, StartCallback, EndCallback);

            Assert.Equal("odasa ", Actions.RunProcessIn[0]);
            Assert.Equal("odasa ", StartCallbackIn[0]);
            Assert.Equal("", EndCallbackIn[0]);
            Assert.Equal(0, EndCallbackReturn[0]);

            Assert.Equal("abc def ghi", Actions.RunProcessIn[1]);
            Assert.Equal("abc def ghi", StartCallbackIn[1]);
            Assert.Equal("", EndCallbackIn[1]);
            Assert.Equal(1, EndCallbackReturn[1]);
        }

        [Fact]
        public void TestOr1()
        {
            var cmd = BuildScript.Create("odasa", null, false, null, null) | BuildScript.Create("abc", "def ghi", false, null, null);

            Actions.RunProcess["abc def ghi"] = 1;
            Actions.RunProcess["odasa "] = 0;
            cmd.Run(Actions, StartCallback, EndCallback);

            Assert.Equal("odasa ", Actions.RunProcessIn[0]);
            Assert.Equal("odasa ", StartCallbackIn[0]);
            Assert.Equal("", EndCallbackIn[0]);
            Assert.Equal(0, EndCallbackReturn[0]);
            Assert.Equal(1, EndCallbackReturn.Count);
        }

        [Fact]
        public void TestOr2()
        {
            var cmd = BuildScript.Create("abc", "def ghi", false, null, null) | BuildScript.Create("odasa", null, false, null, null);

            Actions.RunProcess["abc def ghi"] = 1;
            Actions.RunProcess["odasa "] = 0;
            cmd.Run(Actions, StartCallback, EndCallback);

            Assert.Equal("abc def ghi", Actions.RunProcessIn[0]);
            Assert.Equal("abc def ghi", StartCallbackIn[0]);
            Assert.Equal("", EndCallbackIn[0]);
            Assert.Equal(1, EndCallbackReturn[0]);

            Assert.Equal("odasa ", Actions.RunProcessIn[1]);
            Assert.Equal("odasa ", StartCallbackIn[1]);
            Assert.Equal("", EndCallbackIn[1]);
            Assert.Equal(0, EndCallbackReturn[1]);
        }

        [Fact]
        public void TestSuccess()
        {
            Assert.Equal(0, BuildScript.Success.Run(Actions, StartCallback, EndCallback));
        }

        [Fact]
        public void TestFailure()
        {
            Assert.NotEqual(0, BuildScript.Failure.Run(Actions, StartCallback, EndCallback));
        }

        [Fact]
        public void TestDeleteDirectorySuccess()
        {
            Actions.DirectoryExists["trap"] = true;
            Assert.Equal(0, BuildScript.DeleteDirectory("trap").Run(Actions, StartCallback, EndCallback));
            Assert.Equal("trap", Actions.DirectoryDeleteIn[0]);
        }

        [Fact]
        public void TestDeleteDirectoryFailure()
        {
            Actions.DirectoryExists["trap"] = false;
            Assert.NotEqual(0, BuildScript.DeleteDirectory("trap").Run(Actions, StartCallback, EndCallback));
        }

        [Fact]
        public void TestDeleteFileSuccess()
        {
            Actions.FileExists["csharp.log"] = true;
            Assert.Equal(0, BuildScript.DeleteFile("csharp.log").Run(Actions, StartCallback, EndCallback));
            Assert.Equal("csharp.log", Actions.FileExistsIn[0]);
            Assert.Equal("csharp.log", Actions.FileDeleteIn[0]);
        }

        [Fact]
        public void TestDeleteFileFailure()
        {
            Actions.FileExists["csharp.log"] = false;
            Assert.NotEqual(0, BuildScript.DeleteFile("csharp.log").Run(Actions, StartCallback, EndCallback));
            Assert.Equal("csharp.log", Actions.FileExistsIn[0]);
        }

        [Fact]
        public void TestTry()
        {
            Assert.Equal(0, BuildScript.Try(BuildScript.Failure).Run(Actions, StartCallback, EndCallback));
        }

        CSharpAutobuilder CreateAutoBuilder(bool isWindows,
            string? buildless = null, string? solution = null, string? buildCommand = null, string? ignoreErrors = null,
            string? msBuildArguments = null, string? msBuildPlatform = null, string? msBuildConfiguration = null, string? msBuildTarget = null,
            string? dotnetArguments = null, string? dotnetVersion = null, string? vsToolsVersion = null,
            string? nugetRestore = null, string? allSolutions = null,
            string cwd = @"C:\Project")
        {
            string codeqlUpperLanguage = Language.CSharp.UpperCaseName;
            Actions.GetEnvironmentVariable[$"CODEQL_AUTOBUILDER_{codeqlUpperLanguage}_NO_INDEXING"] = "false";
            Actions.GetEnvironmentVariable[$"CODEQL_EXTRACTOR_{codeqlUpperLanguage}_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable[$"CODEQL_EXTRACTOR_{codeqlUpperLanguage}_SOURCE_ARCHIVE_DIR"] = "";
            Actions.GetEnvironmentVariable[$"CODEQL_EXTRACTOR_{codeqlUpperLanguage}_ROOT"] = $@"C:\codeql\{codeqlUpperLanguage.ToLowerInvariant()}";
            Actions.GetEnvironmentVariable["CODEQL_JAVA_HOME"] = @"C:\codeql\tools\java";
            Actions.GetEnvironmentVariable["SEMMLE_DIST"] = @"C:\odasa";
            Actions.GetEnvironmentVariable["SEMMLE_JAVA_HOME"] = @"C:\odasa\tools\java";
            Actions.GetEnvironmentVariable["SEMMLE_PLATFORM_TOOLS"] = @"C:\odasa\tools";
            Actions.GetEnvironmentVariable["LGTM_INDEX_VSTOOLS_VERSION"] = vsToolsVersion;
            Actions.GetEnvironmentVariable["LGTM_INDEX_MSBUILD_ARGUMENTS"] = msBuildArguments;
            Actions.GetEnvironmentVariable["LGTM_INDEX_MSBUILD_PLATFORM"] = msBuildPlatform;
            Actions.GetEnvironmentVariable["LGTM_INDEX_MSBUILD_CONFIGURATION"] = msBuildConfiguration;
            Actions.GetEnvironmentVariable["LGTM_INDEX_MSBUILD_TARGET"] = msBuildTarget;
            Actions.GetEnvironmentVariable["LGTM_INDEX_DOTNET_ARGUMENTS"] = dotnetArguments;
            Actions.GetEnvironmentVariable["LGTM_INDEX_DOTNET_VERSION"] = dotnetVersion;
            Actions.GetEnvironmentVariable["LGTM_INDEX_BUILD_COMMAND"] = buildCommand;
            Actions.GetEnvironmentVariable["LGTM_INDEX_SOLUTION"] = solution;
            Actions.GetEnvironmentVariable["LGTM_INDEX_IGNORE_ERRORS"] = ignoreErrors;
            Actions.GetEnvironmentVariable["LGTM_INDEX_BUILDLESS"] = buildless;
            Actions.GetEnvironmentVariable["LGTM_INDEX_ALL_SOLUTIONS"] = allSolutions;
            Actions.GetEnvironmentVariable["LGTM_INDEX_NUGET_RESTORE"] = nugetRestore;
            Actions.GetEnvironmentVariable["ProgramFiles(x86)"] = isWindows ? @"C:\Program Files (x86)" : null;
            Actions.GetCurrentDirectory = cwd;
            Actions.IsWindows = isWindows;

            var options = new AutobuildOptions(Actions, Language.CSharp);
            return new CSharpAutobuilder(Actions, options);
        }

        [Fact]
        public void TestDefaultCSharpAutoBuilder()
        {
            Actions.RunProcess["cmd.exe /C dotnet --info"] = 0;
            Actions.RunProcess["cmd.exe /C dotnet clean test.csproj"] = 0;
            Actions.RunProcess["cmd.exe /C dotnet restore test.csproj"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --auto dotnet build --no-incremental test.csproj"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists["test.csproj"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbar.cs\ntest.csproj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            var xml = new XmlDocument();
            xml.LoadXml(@"<Project Sdk=""Microsoft.NET.Sdk"">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

</Project>");
            Actions.LoadXml["test.csproj"] = xml;

            var autobuilder = CreateAutoBuilder(true);
            TestAutobuilderScript(autobuilder, 0, 6);
        }

        [Fact]
        public void TestLinuxCSharpAutoBuilder()
        {
            Actions.RunProcess["dotnet --list-runtimes"] = 0;
            Actions.RunProcessOut["dotnet --list-runtimes"] = @"Microsoft.AspNetCore.App 2.2.5 [/usr/local/share/dotnet/shared/Microsoft.AspNetCore.App]
Microsoft.NETCore.App 2.2.5 [/usr/local/share/dotnet/shared/Microsoft.NETCore.App]";
            Actions.RunProcess["dotnet --info"] = 0;
            Actions.RunProcess["dotnet clean test.csproj"] = 0;
            Actions.RunProcess["dotnet restore test.csproj"] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto dotnet build --no-incremental /p:UseSharedCompilation=false test.csproj"] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists["test.csproj"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs\ntest.csproj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            var xml = new XmlDocument();
            xml.LoadXml(@"<Project Sdk=""Microsoft.NET.Sdk"">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

</Project>");
            Actions.LoadXml["test.csproj"] = xml;

            var autobuilder = CreateAutoBuilder(false);
            TestAutobuilderScript(autobuilder, 0, 7);
        }

        [Fact]
        public void TestLinuxCSharpAutoBuilderExtractorFailed()
        {
            Actions.FileExists["csharp.log"] = false;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(false);
            TestAutobuilderScript(autobuilder, 1, 0);
        }

        [Fact]
        public void TestVsWhereSucceeded()
        {
            Actions.IsWindows = true;
            Actions.GetEnvironmentVariable["ProgramFiles(x86)"] = @"C:\Program Files (x86)";
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = true;
            Actions.RunProcess[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe -prerelease -legacy -property installationPath"] = 0;
            Actions.RunProcessOut[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe -prerelease -legacy -property installationPath"] = "C:\\VS1\nC:\\VS2";
            Actions.RunProcessOut[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe -prerelease -legacy -property installationVersion"] = "10.0\n11.0";
            Actions.RunProcess[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe -prerelease -legacy -property installationVersion"] = 0;

            var candidates = BuildTools.GetCandidateVcVarsFiles(Actions).ToArray();
            Assert.Equal("C:\\VS1\\VC\\vcvarsall.bat", candidates[0].Path);
            Assert.Equal(10, candidates[0].ToolsVersion);
            Assert.Equal("C:\\VS2\\VC\\vcvarsall.bat", candidates[1].Path);
            Assert.Equal(11, candidates[1].ToolsVersion);
        }

        [Fact]
        public void TestVsWhereNotExist()
        {
            Actions.IsWindows = true;
            Actions.GetEnvironmentVariable["ProgramFiles(x86)"] = @"C:\Program Files (x86)";
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;

            var candidates = BuildTools.GetCandidateVcVarsFiles(Actions).ToArray();
            Assert.Equal(4, candidates.Length);
        }

        [Fact]
        public void TestVcVarsAllBatFiles()
        {
            Actions.IsWindows = true;
            Actions.GetEnvironmentVariable["ProgramFiles(x86)"] = @"C:\Program Files (x86)";
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = false;

            var vcvarsfiles = BuildTools.VcVarsAllBatFiles(Actions).ToArray();
            Assert.Equal(2, vcvarsfiles.Length);
        }

        [Fact]
        public void TestLinuxBuildlessExtractionSuccess()
        {
            Actions.RunProcess[@"C:\odasa\tools/csharp/Semmle.Extraction.CSharp.Standalone --references:."] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(false, buildless: "true");
            TestAutobuilderScript(autobuilder, 0, 3);
        }

        [Fact]
        public void TestLinuxBuildlessExtractionFailed()
        {
            Actions.RunProcess[@"C:\odasa\tools/csharp/Semmle.Extraction.CSharp.Standalone --references:."] = 10;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(false, buildless: "true");
            TestAutobuilderScript(autobuilder, 10, 1);
        }

        [Fact]
        public void TestLinuxBuildlessExtractionSolution()
        {
            Actions.RunProcess[@"C:\odasa\tools/csharp/Semmle.Extraction.CSharp.Standalone foo.sln --references:."] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(false, buildless: "true", solution: "foo.sln");
            TestAutobuilderScript(autobuilder, 0, 3);
        }

        void SkipVsWhere()
        {
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = false;
        }

        void TestAutobuilderScript(Autobuilder autobuilder, int expectedOutput, int commandsRun)
        {
            Assert.Equal(expectedOutput, autobuilder.GetBuildScript().Run(Actions, StartCallback, EndCallback));

            // Check expected commands actually ran
            Assert.Equal(commandsRun, StartCallbackIn.Count);
            Assert.Equal(commandsRun, EndCallbackIn.Count);
            Assert.Equal(commandsRun, EndCallbackReturn.Count);

            var action = Actions.RunProcess.GetEnumerator();
            for (int cmd = 0; cmd < commandsRun; ++cmd)
            {
                Assert.True(action.MoveNext());

                Assert.Equal(action.Current.Key, StartCallbackIn[cmd]);
                Assert.Equal(action.Current.Value, EndCallbackReturn[cmd]);
            }
        }

        [Fact]
        public void TestLinuxBuildCommand()
        {
            Actions.RunProcess["dotnet --list-runtimes"] = 1;
            Actions.RunProcessOut["dotnet --list-runtimes"] = "";
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto ""./build.sh --skip-tests"""] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            SkipVsWhere();

            var autobuilder = CreateAutoBuilder(false, buildCommand: "./build.sh --skip-tests");
            TestAutobuilderScript(autobuilder, 0, 4);
        }

        [Fact]
        public void TestLinuxBuildSh()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild/build.sh";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.RunProcess["/bin/chmod u+x build/build.sh"] = 0;
            Actions.RunProcess["dotnet --list-runtimes"] = 1;
            Actions.RunProcessOut["dotnet --list-runtimes"] = "";
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto build/build.sh"] = 0;
            Actions.RunProcessWorkingDirectory[@"C:\odasa/tools/odasa index --auto build/build.sh"] = "build";
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;

            var autobuilder = CreateAutoBuilder(false);
            TestAutobuilderScript(autobuilder, 0, 5);
        }

        [Fact]
        public void TestLinuxBuildShCSharpLogMissing()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild.sh";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";

            Actions.RunProcess["/bin/chmod u+x build.sh"] = 0;
            Actions.RunProcess["dotnet --list-runtimes"] = 1;
            Actions.RunProcessOut["dotnet --list-runtimes"] = "";
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto build.sh"] = 0;
            Actions.RunProcessWorkingDirectory[@"C:\odasa/tools/odasa index --auto build.sh"] = "";
            Actions.FileExists["csharp.log"] = false;

            var autobuilder = CreateAutoBuilder(false);
            TestAutobuilderScript(autobuilder, 1, 3);
        }

        [Fact]
        public void TestLinuxBuildShFailed()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild.sh";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";

            Actions.RunProcess["/bin/chmod u+x build.sh"] = 0;
            Actions.RunProcess["dotnet --list-runtimes"] = 1;
            Actions.RunProcessOut["dotnet --list-runtimes"] = "";
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto build.sh"] = 5;
            Actions.RunProcessWorkingDirectory[@"C:\odasa/tools/odasa index --auto build.sh"] = "";
            Actions.FileExists["csharp.log"] = true;

            var autobuilder = CreateAutoBuilder(false);
            TestAutobuilderScript(autobuilder, 1, 3);
        }

        [Fact]
        public void TestWindowsBuildBat()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild.bat";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --auto build.bat"] = 0;
            Actions.RunProcessWorkingDirectory[@"cmd.exe /C C:\odasa\tools\odasa index --auto build.bat"] = "";
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;

            var autobuilder = CreateAutoBuilder(true);
            TestAutobuilderScript(autobuilder, 0, 3);
        }

        [Fact]
        public void TestWindowsBuildBatIgnoreErrors()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild.bat";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --auto build.bat"] = 1;
            Actions.RunProcessWorkingDirectory[@"cmd.exe /C C:\odasa\tools\odasa index --auto build.bat"] = "";
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config"] = 0;
            Actions.FileExists["csharp.log"] = true;

            var autobuilder = CreateAutoBuilder(true, ignoreErrors: "true");
            TestAutobuilderScript(autobuilder, 1, 1);
        }

        [Fact]
        public void TestWindowsCmdIgnoreErrors()
        {
            Actions.RunProcess["cmd.exe /C C:\\odasa\\tools\\odasa index --auto ^\"build.cmd --skip-tests^\""] = 3;
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config"] = 0;
            Actions.FileExists["csharp.log"] = true;
            SkipVsWhere();

            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(true, buildCommand: "build.cmd --skip-tests", ignoreErrors: "true");
            TestAutobuilderScript(autobuilder, 3, 1);
        }

        [Fact]
        public void TestWindowCSharpMsBuild()
        {
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore C:\Project\test1.sln"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && set Platform=&& type NUL && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test1.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore C:\Project\test2.sln"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && set Platform=&& type NUL && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test2.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;

            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest1.cs\ntest2.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(true, msBuildArguments: "/P:Fu=Bar", msBuildTarget: "Windows", msBuildPlatform: "x86", msBuildConfiguration: "Debug",
                vsToolsVersion: "12", allSolutions: "true");
            var testSolution1 = new TestSolution(@"C:\Project\test1.sln");
            var testSolution2 = new TestSolution(@"C:\Project\test2.sln");
            autobuilder.ProjectsOrSolutionsToBuild.Add(testSolution1);
            autobuilder.ProjectsOrSolutionsToBuild.Add(testSolution2);

            TestAutobuilderScript(autobuilder, 0, 6);
        }

        [Fact]
        public void TestWindowCSharpMsBuildMultipleSolutions()
        {
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore test1.csproj"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && set Platform=&& type NUL && C:\\odasa\\tools\\odasa index --auto msbuild test1.csproj /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore test2.csproj"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && set Platform=&& type NUL && C:\\odasa\\tools\\odasa index --auto msbuild test2.csproj /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists[@"test1.csproj"] = true;
            Actions.FileExists[@"test2.csproj"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;

            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "test1.csproj\ntest2.csproj\ntest1.cs\ntest2.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var csproj1 = new XmlDocument();
            csproj1.LoadXml(@"<?xml version=""1.0"" encoding=""utf - 8""?>
  <Project ToolsVersion=""15.0"" xmlns=""http://schemas.microsoft.com/developer/msbuild/2003"">
    <ItemGroup>
      <Compile Include=""test1.cs"" />
    </ItemGroup>
  </Project>");
            Actions.LoadXml["test1.csproj"] = csproj1;

            var csproj2 = new XmlDocument();
            csproj2.LoadXml(@"<?xml version=""1.0"" encoding=""utf - 8""?>
  <Project ToolsVersion=""15.0"" xmlns=""http://schemas.microsoft.com/developer/msbuild/2003"">
    <ItemGroup>
      <Compile Include=""test1.cs"" />
    </ItemGroup>
  </Project>");
            Actions.LoadXml["test2.csproj"] = csproj2;

            var autobuilder = CreateAutoBuilder(true, msBuildArguments: "/P:Fu=Bar", msBuildTarget: "Windows", msBuildPlatform: "x86", msBuildConfiguration: "Debug",
                vsToolsVersion: "12");

            TestAutobuilderScript(autobuilder, 0, 6);
        }

        [Fact]
        public void TestWindowCSharpMsBuildFailed()
        {
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore C:\Project\test1.sln"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && set Platform=&& type NUL && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test1.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 1;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest1.cs\ntest2.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(true, msBuildArguments: "/P:Fu=Bar", msBuildTarget: "Windows", msBuildPlatform: "x86", msBuildConfiguration: "Debug",
                vsToolsVersion: "12", allSolutions: "true");
            var testSolution1 = new TestSolution(@"C:\Project\test1.sln");
            var testSolution2 = new TestSolution(@"C:\Project\test2.sln");
            autobuilder.ProjectsOrSolutionsToBuild.Add(testSolution1);
            autobuilder.ProjectsOrSolutionsToBuild.Add(testSolution2);

            TestAutobuilderScript(autobuilder, 1, 2);
        }


        [Fact]
        public void TestSkipNugetMsBuild()
        {
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && set Platform=&& type NUL && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test1.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && set Platform=&& type NUL && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test2.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest1.cs\ntest2.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(true, msBuildArguments: "/P:Fu=Bar", msBuildTarget: "Windows",
                msBuildPlatform: "x86", msBuildConfiguration: "Debug", vsToolsVersion: "12",
                allSolutions: "true", nugetRestore: "false");
            var testSolution1 = new TestSolution(@"C:\Project\test1.sln");
            var testSolution2 = new TestSolution(@"C:\Project\test2.sln");
            autobuilder.ProjectsOrSolutionsToBuild.Add(testSolution1);
            autobuilder.ProjectsOrSolutionsToBuild.Add(testSolution2);

            TestAutobuilderScript(autobuilder, 0, 4);
        }

        [Fact]
        public void TestSkipNugetBuildless()
        {
            Actions.RunProcess[@"C:\odasa\tools/csharp/Semmle.Extraction.CSharp.Standalone foo.sln --references:. --skip-nuget"] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(false, buildless: "true", solution: "foo.sln", nugetRestore: "false");
            TestAutobuilderScript(autobuilder, 0, 3);
        }


        [Fact]
        public void TestSkipNugetDotnet()
        {
            Actions.RunProcess["dotnet --list-runtimes"] = 0;
            Actions.RunProcessOut["dotnet --list-runtimes"] = @"Microsoft.AspNetCore.App 2.1.3 [/usr/local/share/dotnet/shared/Microsoft.AspNetCore.App]
Microsoft.NETCore.App 2.1.3 [/usr/local/share/dotnet/shared/Microsoft.NETCore.App]";
            Actions.RunProcess["dotnet --info"] = 0;
            Actions.RunProcess["dotnet clean test.csproj"] = 0;
            Actions.RunProcess["dotnet restore test.csproj"] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto dotnet build --no-incremental /p:UseSharedCompilation=false --no-restore test.csproj"] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists["test.csproj"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs\ntest.csproj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            var xml = new XmlDocument();
            xml.LoadXml(@"<Project Sdk=""Microsoft.NET.Sdk"">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

</Project>");
            Actions.LoadXml["test.csproj"] = xml;

            var autobuilder = CreateAutoBuilder(false, dotnetArguments: "--no-restore");  // nugetRestore=false does not work for now.
            TestAutobuilderScript(autobuilder, 0, 7);
        }

        [Fact]
        public void TestDotnetVersionNotInstalled()
        {
            Actions.RunProcess["dotnet --list-sdks"] = 0;
            Actions.RunProcessOut["dotnet --list-sdks"] = "2.1.2 [C:\\Program Files\\dotnet\\sdks]\n2.1.4 [C:\\Program Files\\dotnet\\sdks]";
            Actions.RunProcess[@"curl -L -sO https://dot.net/v1/dotnet-install.sh"] = 0;
            Actions.RunProcess[@"chmod u+x dotnet-install.sh"] = 0;
            Actions.RunProcess[@"./dotnet-install.sh --channel release --version 2.1.3 --install-dir C:\Project/.dotnet"] = 0;
            Actions.RunProcess[@"rm dotnet-install.sh"] = 0;
            Actions.RunProcess[@"C:\Project/.dotnet/dotnet --list-runtimes"] = 0;
            Actions.RunProcessOut[@"C:\Project/.dotnet/dotnet --list-runtimes"] = @"Microsoft.AspNetCore.App 3.0.0 [/usr/local/share/dotnet/shared/Microsoft.AspNetCore.App]
Microsoft.NETCore.App 3.0.0 [/usr/local/share/dotnet/shared/Microsoft.NETCore.App]";
            Actions.RunProcess[@"C:\Project/.dotnet/dotnet --info"] = 0;
            Actions.RunProcess[@"C:\Project/.dotnet/dotnet clean test.csproj"] = 0;
            Actions.RunProcess[@"C:\Project/.dotnet/dotnet restore test.csproj"] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto C:\Project/.dotnet/dotnet build --no-incremental test.csproj"] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists["test.csproj"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.GetEnvironmentVariable["PATH"] = "/bin:/usr/bin";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs\ntest.csproj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            var xml = new XmlDocument();
            xml.LoadXml(@"<Project Sdk=""Microsoft.NET.Sdk"">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

</Project>");
            Actions.LoadXml["test.csproj"] = xml;

            var autobuilder = CreateAutoBuilder(false, dotnetVersion: "2.1.3");
            TestAutobuilderScript(autobuilder, 0, 12);
        }

        [Fact]
        public void TestDotnetVersionAlreadyInstalled()
        {
            Actions.RunProcess["dotnet --list-sdks"] = 0;
            Actions.RunProcessOut["dotnet --list-sdks"] = @"2.1.3 [C:\Program Files\dotnet\sdks]
2.1.4 [C:\Program Files\dotnet\sdks]";
            Actions.RunProcess[@"curl -L -sO https://dot.net/v1/dotnet-install.sh"] = 0;
            Actions.RunProcess[@"chmod u+x dotnet-install.sh"] = 0;
            Actions.RunProcess[@"./dotnet-install.sh --channel release --version 2.1.3 --install-dir C:\Project/.dotnet"] = 0;
            Actions.RunProcess[@"rm dotnet-install.sh"] = 0;
            Actions.RunProcess[@"C:\Project/.dotnet/dotnet --list-runtimes"] = 0;
            Actions.RunProcessOut[@"C:\Project/.dotnet/dotnet --list-runtimes"] = @"Microsoft.AspNetCore.App 2.1.3 [/usr/local/share/dotnet/shared/Microsoft.AspNetCore.App]
Microsoft.AspNetCore.App 2.1.4 [/usr/local/share/dotnet/shared/Microsoft.AspNetCore.App]
Microsoft.NETCore.App 2.1.3 [/usr/local/share/dotnet/shared/Microsoft.NETCore.App]
Microsoft.NETCore.App 2.1.4 [/usr/local/share/dotnet/shared/Microsoft.NETCore.App]";
            Actions.RunProcess[@"C:\Project/.dotnet/dotnet --info"] = 0;
            Actions.RunProcess[@"C:\Project/.dotnet/dotnet clean test.csproj"] = 0;
            Actions.RunProcess[@"C:\Project/.dotnet/dotnet restore test.csproj"] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto C:\Project/.dotnet/dotnet build --no-incremental /p:UseSharedCompilation=false test.csproj"] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists["test.csproj"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.GetEnvironmentVariable["PATH"] = "/bin:/usr/bin";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbar.cs\ntest.csproj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            var xml = new XmlDocument();
            xml.LoadXml(@"<Project Sdk=""Microsoft.NET.Sdk"">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

</Project>");
            Actions.LoadXml["test.csproj"] = xml;

            var autobuilder = CreateAutoBuilder(false, dotnetVersion: "2.1.3");
            TestAutobuilderScript(autobuilder, 0, 12);
        }

        [Fact]
        public void TestDotnetVersionWindows()
        {
            Actions.RunProcess["cmd.exe /C dotnet --list-sdks"] = 0;
            Actions.RunProcessOut["cmd.exe /C dotnet --list-sdks"] = "2.1.3 [C:\\Program Files\\dotnet\\sdks]\n2.1.4 [C:\\Program Files\\dotnet\\sdks]";
            Actions.RunProcess[@"cmd.exe /C powershell -NoProfile -ExecutionPolicy unrestricted -file C:\Project\install-dotnet.ps1 -Version 2.1.3 -InstallDir C:\Project\.dotnet"] = 0;
            Actions.RunProcess[@"cmd.exe /C del C:\Project\install-dotnet.ps1"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\Project\.dotnet\dotnet --info"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\Project\.dotnet\dotnet clean test.csproj"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\Project\.dotnet\dotnet restore test.csproj"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --auto C:\Project\.dotnet\dotnet build --no-incremental test.csproj"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists["test.csproj"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.GetEnvironmentVariable["PATH"] = "/bin:/usr/bin";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs\ntest.csproj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            var xml = new XmlDocument();
            xml.LoadXml(@"<Project Sdk=""Microsoft.NET.Sdk"">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

</Project>");
            Actions.LoadXml["test.csproj"] = xml;

            var autobuilder = CreateAutoBuilder(true, dotnetVersion: "2.1.3");
            TestAutobuilderScript(autobuilder, 0, 9);
        }

        [Fact]
        public void TestDirsProjWindows()
        {
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore dirs.proj"] = 1;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && set Platform=&& type NUL && C:\\odasa\\tools\\odasa index --auto msbuild dirs.proj /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\codeql\tools\java\bin\java -jar C:\codeql\csharp\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists[@"a\test.csproj"] = true;
            Actions.FileExists["dirs.proj"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;

            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "a\\test.cs\na\\test.csproj\ndirs.proj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var csproj = new XmlDocument();
            csproj.LoadXml(@"<?xml version=""1.0"" encoding=""utf - 8""?>
  <Project ToolsVersion=""15.0"" xmlns=""http://schemas.microsoft.com/developer/msbuild/2003"">
    <ItemGroup>
      <Compile Include=""test.cs"" />
    </ItemGroup>
  </Project>");
            Actions.LoadXml["a\\test.csproj"] = csproj;

            var dirsproj = new XmlDocument();
            dirsproj.LoadXml(@"<Project DefaultTargets=""Build"" xmlns=""http://schemas.microsoft.com/developer/msbuild/2003"" ToolsVersion=""3.5"">
  <ItemGroup>
    <ProjectFiles Include=""a\test.csproj"" />
  </ItemGroup>
</Project>");
            Actions.LoadXml["dirs.proj"] = dirsproj;

            var autobuilder = CreateAutoBuilder(true, msBuildArguments: "/P:Fu=Bar", msBuildTarget: "Windows", msBuildPlatform: "x86", msBuildConfiguration: "Debug",
                vsToolsVersion: "12", allSolutions: "true");
            TestAutobuilderScript(autobuilder, 0, 4);
        }

        [Fact]
        public void TestDirsProjLinux()
        {
            Actions.RunProcess[@"mono C:\odasa\tools/csharp/nuget/nuget.exe restore dirs.proj"] = 1;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --auto msbuild dirs.proj /p:UseSharedCompilation=false /t:rebuild /p:MvcBuildViews=true"] = 0;
            Actions.RunProcess[@"C:\codeql\tools\java/bin/java -jar C:\codeql\csharp/tools/extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa/tools/odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists["a/test.csproj"] = true;
            Actions.FileExists["dirs.proj"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.EnumerateFiles[@"C:\Project"] = "a/test.cs\na/test.csproj\ndirs.proj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var csproj = new XmlDocument();
            csproj.LoadXml(@"<?xml version=""1.0"" encoding=""utf - 8""?>
  <Project ToolsVersion=""15.0"" xmlns=""http://schemas.microsoft.com/developer/msbuild/2003"">
    <ItemGroup>
      <Compile Include=""test.cs"" />
    </ItemGroup>
  </Project>");
            Actions.LoadXml["a/test.csproj"] = csproj;

            var dirsproj = new XmlDocument();
            dirsproj.LoadXml(@"<Project DefaultTargets=""Build"" xmlns=""http://schemas.microsoft.com/developer/msbuild/2003"" ToolsVersion=""3.5"">
  <ItemGroup>
    <ProjectFiles Include=""a\test.csproj"" />
  </ItemGroup>
</Project>");
            Actions.LoadXml["dirs.proj"] = dirsproj;

            var autobuilder = CreateAutoBuilder(false);
            TestAutobuilderScript(autobuilder, 0, 4);
        }

        [Fact]
        public void TestCyclicDirsProj()
        {
            Actions.FileExists["dirs.proj"] = true;
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable["CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"] = "";
            Actions.FileExists["csharp.log"] = false;
            Actions.EnumerateFiles[@"C:\Project"] = "dirs.proj";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var dirsproj1 = new XmlDocument();
            dirsproj1.LoadXml(@"<Project DefaultTargets=""Build"" xmlns=""http://schemas.microsoft.com/developer/msbuild/2003"" ToolsVersion=""3.5"">
  <ItemGroup>
    <ProjectFiles Include=""dirs.proj"" />
  </ItemGroup>
</Project>");
            Actions.LoadXml["dirs.proj"] = dirsproj1;

            var autobuilder = CreateAutoBuilder(false);
            TestAutobuilderScript(autobuilder, 1, 0);
        }

        [Fact]
        public void TestAsStringWithExpandedEnvVarsWindows()
        {
            Actions.IsWindows = true;
            Actions.GetEnvironmentVariable["LGTM_SRC"] = @"C:\repo";
            Assert.Equal(@"C:\repo\test", @"%LGTM_SRC%\test".AsStringWithExpandedEnvVars(Actions));
        }

        [Fact]
        public void TestAsStringWithExpandedEnvVarsLinux()
        {
            Actions.IsWindows = false;
            Actions.GetEnvironmentVariable["LGTM_SRC"] = "/tmp/repo";
            Assert.Equal("/tmp/repo/test", "$LGTM_SRC/test".AsStringWithExpandedEnvVars(Actions));
        }
    }
}
