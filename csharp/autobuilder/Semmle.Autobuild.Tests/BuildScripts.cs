﻿using Xunit;
using Semmle.Autobuild;
using System.Collections.Generic;
using System;
using System.Linq;
using Microsoft.Build.Construction;

namespace Semmle.Extraction.Tests
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
        public IList<string> FileDeleteIn = new List<string>();

        void IBuildActions.FileDelete(string file)
        {
            FileDeleteIn.Add(file);
        }

        public IList<string> FileExistsIn = new List<string>();
        public IDictionary<string, bool> FileExists = new Dictionary<string, bool>();

        bool IBuildActions.FileExists(string file)
        {
            FileExistsIn.Add(file);
            if (FileExists.TryGetValue(file, out var ret))
                return ret;
            if (FileExists.TryGetValue(System.IO.Path.GetFileName(file), out ret))
                return ret;
            throw new ArgumentException("Missing FileExists " + file);
        }

        public IList<string> RunProcessIn = new List<string>();
        public IDictionary<string, int> RunProcess = new Dictionary<string, int>();
        public IDictionary<string, string> RunProcessOut = new Dictionary<string, string>();
        public IDictionary<string, string> RunProcessWorkingDirectory = new Dictionary<string, string>();

        int IBuildActions.RunProcess(string cmd, string args, string workingDirectory, IDictionary<string, string> env, out IList<string> stdOut)
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

        int IBuildActions.RunProcess(string cmd, string args, string workingDirectory, IDictionary<string, string> env)
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

        public IList<string> DirectoryDeleteIn = new List<string>();

        void IBuildActions.DirectoryDelete(string dir, bool recursive)
        {
            DirectoryDeleteIn.Add(dir);
        }

        public IDictionary<string, bool> DirectoryExists = new Dictionary<string, bool>();
        public IList<string> DirectoryExistsIn = new List<string>();

        bool IBuildActions.DirectoryExists(string dir)
        {
            DirectoryExistsIn.Add(dir);
            if (DirectoryExists.TryGetValue(dir, out var ret))
                return ret;
            throw new ArgumentException("Missing DirectoryExists " + dir);
        }

        public IDictionary<string, string> GetEnvironmentVariable = new Dictionary<string, string>();

        string IBuildActions.GetEnvironmentVariable(string name)
        {
            if (GetEnvironmentVariable.TryGetValue(name, out var ret))
                return ret;
            throw new ArgumentException("Missing GetEnvironmentVariable " + name);
        }

        public string GetCurrentDirectory;

        string IBuildActions.GetCurrentDirectory()
        {
            return GetCurrentDirectory;
        }

        public IDictionary<string, string> EnumerateFiles = new Dictionary<string, string>();

        IEnumerable<string> IBuildActions.EnumerateFiles(string dir)
        {
            if (EnumerateFiles.TryGetValue(dir, out var str))
                return str.Split("\n");
            throw new ArgumentException("Missing EnumerateFiles " + dir);
        }

        public IDictionary<string, string> EnumerateDirectories = new Dictionary<string, string>();

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
            return string.Join('\\', parts);
        }

        void IBuildActions.WriteAllText(string filename, string contents)
        {
        }
    }

    /// <summary>
    /// A fake solution to build.
    /// </summary>
    class TestSolution : ISolution
    {
        public IEnumerable<Project> Projects => throw new NotImplementedException();

        public IEnumerable<SolutionConfigurationInSolution> Configurations => throw new NotImplementedException();

        public string DefaultConfigurationName => "Release";

        public string DefaultPlatformName => "x86";

        public string Path { get; set; }

        public int ProjectCount => throw new NotImplementedException();

        public Version ToolsVersion => new Version("14.0");

        public TestSolution(string path)
        {
            Path = path;
        }
    }

    public class BuildScriptTests
    {
        TestActions Actions = new TestActions();

        // Records the arguments passed to StartCallback.
        IList<string> StartCallbackIn = new List<string>();

        void StartCallback(string s)
        {
            StartCallbackIn.Add(s);
        }

        // Records the arguments passed to EndCallback
        IList<string> EndCallbackIn = new List<string>();
        IList<int> EndCallbackReturn = new List<int>();

        void EndCallback(int ret, string s)
        {
            EndCallbackReturn.Add(ret);
            EndCallbackIn.Add(s);
        }

        [Fact]
        public void TestBuildCommand()
        {
            var cmd = BuildScript.Create("abc", "def ghi", null, null);

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
            var cmd = BuildScript.Create("abc", "def ghi", null, null) & BuildScript.Create("odasa", null, null, null);

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
            var cmd = BuildScript.Create("odasa", null, null, null) & BuildScript.Create("abc", "def ghi", null, null);

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
            var cmd = BuildScript.Create("odasa", null, null, null) | BuildScript.Create("abc", "def ghi", null, null);

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
            var cmd = BuildScript.Create("abc", "def ghi", null, null) | BuildScript.Create("odasa", null, null, null);

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

        Autobuilder CreateAutoBuilder(string lgtmLanguage, bool isWindows,
            string buildless=null, string solution=null, string buildCommand=null, string ignoreErrors=null,
            string msBuildArguments=null, string msBuildPlatform=null, string msBuildConfiguration=null, string msBuildTarget=null,
            string dotnetArguments=null, string dotnetVersion=null, string vsToolsVersion=null,
            string nugetRestore=null, string allSolutions=null,
            string cwd=@"C:\Project")
        {
            Actions.GetEnvironmentVariable["SEMMLE_DIST"] = @"C:\odasa";
            Actions.GetEnvironmentVariable["SEMMLE_JAVA_HOME"] = @"C:\odasa\tools\java";
            Actions.GetEnvironmentVariable["LGTM_PROJECT_LANGUAGE"] = lgtmLanguage;
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

            var options = new AutobuildOptions();
            options.ReadEnvironment(Actions);
            return new Autobuilder(Actions, options);
        }

        [Fact]
        public void TestDefaultCSharpAutoBuilder()
        {
            Actions.RunProcess["cmd.exe /C dotnet --info"] = 0;
            Actions.RunProcess["cmd.exe /C dotnet clean"] = 0;
            Actions.RunProcess["cmd.exe /C dotnet restore"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --auto dotnet build --no-incremental /p:UseSharedCompilation=false"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbar.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", true);
            TestAutobuilderScript(autobuilder, 0, 6);
        }

        [Fact]
        public void TestLinuxCSharpAutoBuilder()
        {
            Actions.RunProcess["dotnet --info"] = 0;
            Actions.RunProcess["dotnet clean"] = 0;
            Actions.RunProcess["dotnet restore"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --auto dotnet build --no-incremental /p:UseSharedCompilation=false"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false);
            TestAutobuilderScript(autobuilder, 0, 6);
        }

        [Fact]
        public void TestLinuxCSharpAutoBuilderExtractorFailed()
        {
            Actions.RunProcess["dotnet --info"] = 0;
            Actions.RunProcess["dotnet clean"] = 0;
            Actions.RunProcess["dotnet restore"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --auto dotnet build --no-incremental /p:UseSharedCompilation=false"] = 0;
            Actions.FileExists["csharp.log"] = false;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false);
            TestAutobuilderScript(autobuilder, 1, 4);
        }


        [Fact]
        public void TestDefaultCppAutobuilder()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("cpp", true);
            var script = autobuilder.GetBuildScript();

            // Fails due to no solutions present.
            Assert.NotEqual(0, script.Run(Actions, StartCallback, EndCallback));
        }

        [Fact]
        public void TestCppAutobuilderSuccess()
        {
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore C:\Project\test.sln"] = 1;
            Actions.RunProcess[@"cmd.exe /C CALL ^""C:\Program Files ^(x86^)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat^"" && C:\odasa\tools\odasa index --auto msbuild C:\Project\test.sln /p:UseSharedCompilation=false /t:rebuild /p:Platform=""x86"" /p:Configuration=""Release"" /p:MvcBuildViews=true"] = 0;
            Actions.RunProcessOut[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe -prerelease -legacy -property installationPath"] = "";
            Actions.RunProcess[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe -prerelease -legacy -property installationPath"] = 1;
            Actions.RunProcess[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe -prerelease -legacy -property installationVersion"] = 0;
            Actions.RunProcessOut[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe -prerelease -legacy -property installationVersion"] = "";
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = true;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.slx";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("cpp", true);
            var solution = new TestSolution(@"C:\Project\test.sln");
            autobuilder.SolutionsToBuild.Add(solution);
            TestAutobuilderScript(autobuilder, 0, 2);
        }

        [Fact]
        public void TestVsWhereSucceeded()
        {
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
            Actions.GetEnvironmentVariable["ProgramFiles(x86)"] = @"C:\Program Files (x86)";
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;

            var candidates = BuildTools.GetCandidateVcVarsFiles(Actions).ToArray();
            Assert.Equal(4, candidates.Length);
        }

        [Fact]
        public void TestVcVarsAllBatFiles()
        {
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
            Actions.RunProcess[@"C:\odasa\tools\csharp\Semmle.Extraction.CSharp.Standalone --references:."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false, buildless:"true");
            TestAutobuilderScript(autobuilder, 0, 3);
        }

        [Fact]
        public void TestLinuxBuildlessExtractionFailed()
        {
            Actions.RunProcess[@"C:\odasa\tools\csharp\Semmle.Extraction.CSharp.Standalone --references:."] = 10;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false, buildless: "true");
            TestAutobuilderScript(autobuilder, 10, 1);
        }

        [Fact]
        public void TestLinuxBuildlessExtractionSolution()
        {
            Actions.RunProcess[@"C:\odasa\tools\csharp\Semmle.Extraction.CSharp.Standalone foo.sln --references:."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false, buildless: "true", solution: "foo.sln");
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
            for(int cmd=0; cmd<commandsRun; ++cmd)
            {
                Assert.True(action.MoveNext());

                Assert.Equal(action.Current.Key, StartCallbackIn[cmd]);
                Assert.Equal(action.Current.Value, EndCallbackReturn[cmd]);
            }
        }

        [Fact]
        public void TestLinuxBuildCommand()
        {
            Actions.RunProcess["C:\\odasa\\tools\\odasa index --auto \"./build.sh --skip-tests\""] = 0;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            SkipVsWhere();

            var autobuilder = CreateAutoBuilder("csharp", false, buildCommand:"./build.sh --skip-tests");
            TestAutobuilderScript(autobuilder, 0, 3);
        }

        [Fact]
        public void TestLinuxBuildSh()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild/build.sh";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.RunProcess["dotnet --info"] = 1;
            Actions.RunProcess["/bin/chmod u+x build/build.sh"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --auto build/build.sh"] = 0;
            Actions.RunProcessWorkingDirectory[@"C:\odasa\tools\odasa index --auto build/build.sh"] = "build";
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;

            var autobuilder = CreateAutoBuilder("csharp", false);
            TestAutobuilderScript(autobuilder, 0, 5);
        }

        [Fact]
        public void TestLinuxBuildShCSharpLogMissing()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild.sh";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;

            Actions.RunProcess["dotnet --info"] = 1;
            Actions.RunProcess["/bin/chmod u+x build.sh"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --auto build.sh"] = 0;
            Actions.RunProcessWorkingDirectory[@"C:\odasa\tools\odasa index --auto build.sh"] = "";
            Actions.FileExists["csharp.log"] = false;

            var autobuilder = CreateAutoBuilder("csharp", false);
            TestAutobuilderScript(autobuilder, 1, 3);
        }

        [Fact]
        public void TestLinuxBuildShFailed()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild.sh";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;

            Actions.RunProcess["dotnet --info"] = 1;
            Actions.RunProcess["/bin/chmod u+x build.sh"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --auto build.sh"] = 5;
            Actions.RunProcessWorkingDirectory[@"C:\odasa\tools\odasa index --auto build.sh"] = "";
            Actions.FileExists["csharp.log"] = true;

            var autobuilder = CreateAutoBuilder("csharp", false);
            TestAutobuilderScript(autobuilder, 1, 3);
        }

        [Fact]
        public void TestWindowsBuildBat()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild.bat";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.RunProcess["cmd.exe /C dotnet --info"] = 1;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --auto build.bat"] = 0;
            Actions.RunProcessWorkingDirectory[@"cmd.exe /C C:\odasa\tools\odasa index --auto build.bat"] = "";
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;

            var autobuilder = CreateAutoBuilder("csharp", true);
            TestAutobuilderScript(autobuilder, 0, 4);
        }

        [Fact]
        public void TestWindowsBuildBatIgnoreErrors()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbuild.bat";
            Actions.EnumerateDirectories[@"C:\Project"] = "";
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.RunProcess["cmd.exe /C dotnet --info"] = 1;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --auto build.bat"] = 1;
            Actions.RunProcessWorkingDirectory[@"cmd.exe /C C:\odasa\tools\odasa index --auto build.bat"] = "";
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config"] = 0;
            Actions.FileExists["csharp.log"] = true;

            var autobuilder = CreateAutoBuilder("csharp", true, ignoreErrors:"true");
            TestAutobuilderScript(autobuilder, 1, 2);
        }

        [Fact]
        public void TestWindowsCmdIgnoreErrors()
        {
            Actions.RunProcess["cmd.exe /C C:\\odasa\\tools\\odasa index --auto ^\"build.cmd --skip-tests^\""] = 3;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config"] = 0;
            Actions.FileExists["csharp.log"] = true;
            SkipVsWhere();

            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", true, buildCommand: "build.cmd --skip-tests", ignoreErrors: "true");
            TestAutobuilderScript(autobuilder, 3, 1);
        }

        [Fact]
        public void TestWindowCSharpMsBuild()
        {
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore C:\Project\test1.sln"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test1.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore C:\Project\test2.sln"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test2.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;

            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest1.cs\ntest2.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", true, msBuildArguments:"/P:Fu=Bar", msBuildTarget:"Windows", msBuildPlatform:"x86", msBuildConfiguration:"Debug",
                vsToolsVersion:"12", allSolutions:"true");
            var testSolution1 = new TestSolution(@"C:\Project\test1.sln");
            var testSolution2 = new TestSolution(@"C:\Project\test2.sln");
            autobuilder.SolutionsToBuild.Add(testSolution1);
            autobuilder.SolutionsToBuild.Add(testSolution2);

            TestAutobuilderScript(autobuilder, 0, 6);
        }

        [Fact]
        public void TestWindowCSharpMsBuildFailed()
        {
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\csharp\nuget\nuget.exe restore C:\Project\test1.sln"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test1.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 1;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest1.cs\ntest2.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", true, msBuildArguments: "/P:Fu=Bar", msBuildTarget: "Windows", msBuildPlatform: "x86", msBuildConfiguration: "Debug",
                vsToolsVersion: "12", allSolutions: "true");
            var testSolution1 = new TestSolution(@"C:\Project\test1.sln");
            var testSolution2 = new TestSolution(@"C:\Project\test2.sln");
            autobuilder.SolutionsToBuild.Add(testSolution1);
            autobuilder.SolutionsToBuild.Add(testSolution2);

            TestAutobuilderScript(autobuilder, 1, 2);
        }


        [Fact]
        public void TestSkipNugetMsBuild()
        {
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test1.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess["cmd.exe /C CALL ^\"C:\\Program Files ^(x86^)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat^\" && C:\\odasa\\tools\\odasa index --auto msbuild C:\\Project\\test2.sln /p:UseSharedCompilation=false /t:Windows /p:Platform=\"x86\" /p:Configuration=\"Debug\" /p:MvcBuildViews=true /P:Fu=Bar"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"] = true;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"] = false;
            Actions.FileExists[@"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest1.cs\ntest2.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", true, msBuildArguments: "/P:Fu=Bar", msBuildTarget: "Windows",
                msBuildPlatform: "x86", msBuildConfiguration: "Debug", vsToolsVersion: "12",
                allSolutions: "true", nugetRestore:"false");
            var testSolution1 = new TestSolution(@"C:\Project\test1.sln");
            var testSolution2 = new TestSolution(@"C:\Project\test2.sln");
            autobuilder.SolutionsToBuild.Add(testSolution1);
            autobuilder.SolutionsToBuild.Add(testSolution2);

            TestAutobuilderScript(autobuilder, 0, 4);
        }

        [Fact]
        public void TestSkipNugetBuildless()
        {
            Actions.RunProcess[@"C:\odasa\tools\csharp\Semmle.Extraction.CSharp.Standalone foo.sln --references:. --skip-nuget"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.sln";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false, buildless: "true", solution: "foo.sln", nugetRestore:"false");
            TestAutobuilderScript(autobuilder, 0, 3);
        }


        [Fact]
        public void TestSkipNugetDotnet()
        {
            Actions.RunProcess["dotnet --info"] = 0;
            Actions.RunProcess["dotnet clean"] = 0;
            Actions.RunProcess["dotnet restore"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --auto dotnet build --no-incremental /p:UseSharedCompilation=false --no-restore"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false, dotnetArguments:"--no-restore");  // nugetRestore=false does not work for now.
            TestAutobuilderScript(autobuilder, 0, 6);
        }

        [Fact]
        public void TestDotnetVersionNotInstalled()
        {
            Actions.RunProcess["dotnet --list-sdks"] = 0;
            Actions.RunProcessOut["dotnet --list-sdks"] = "2.1.2 [C:\\Program Files\\dotnet\\sdks]\n2.1.4 [C:\\Program Files\\dotnet\\sdks]";
            Actions.RunProcess[@"curl -sO https://dot.net/v1/dotnet-install.sh"] = 0;
            Actions.RunProcess[@"chmod u+x dotnet-install.sh"] = 0;
            Actions.RunProcess[@"./dotnet-install.sh --channel release --version 2.1.3 --install-dir C:\Project\.dotnet"] = 0;
            Actions.RunProcess[@"C:\Project\.dotnet\dotnet --info"] = 0;
            Actions.RunProcess[@"C:\Project\.dotnet\dotnet clean"] = 0;
            Actions.RunProcess[@"C:\Project\.dotnet\dotnet restore"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --auto C:\Project\.dotnet\dotnet build --no-incremental /p:UseSharedCompilation=false"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.GetEnvironmentVariable["PATH"] = "/bin:/usr/bin";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false, dotnetVersion:"2.1.3");
            TestAutobuilderScript(autobuilder, 0, 10);
        }

        [Fact]
        public void TestDotnetVersionAlreadyInstalled()
        {
            Actions.RunProcess["dotnet --list-sdks"] = 0;
            Actions.RunProcessOut["dotnet --list-sdks"] = "2.1.3 [C:\\Program Files\\dotnet\\sdks]\n2.1.4 [C:\\Program Files\\dotnet\\sdks]";
            Actions.RunProcess[@"curl -sO https://dot.net/v1/dotnet-install.sh"] = 0;
            Actions.RunProcess[@"chmod u+x dotnet-install.sh"] = 0;
            Actions.RunProcess[@"./dotnet-install.sh --channel release --version 2.1.3 --install-dir C:\Project\.dotnet"] = 0;
            Actions.RunProcess[@"C:\Project\.dotnet\dotnet --info"] = 0;
            Actions.RunProcess[@"C:\Project\.dotnet\dotnet clean"] = 0;
            Actions.RunProcess[@"C:\Project\.dotnet\dotnet restore"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --auto C:\Project\.dotnet\dotnet build --no-incremental /p:UseSharedCompilation=false"] = 0;
            Actions.RunProcess[@"C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.GetEnvironmentVariable["PATH"] = "/bin:/usr/bin";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\nbar.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", false, dotnetVersion: "2.1.3");
            TestAutobuilderScript(autobuilder, 0, 10);
        }

        [Fact]
        public void TestDotnetVersionWindows()
        {
            Actions.RunProcess["cmd.exe /C dotnet --list-sdks"] = 0;
            Actions.RunProcessOut["cmd.exe /C dotnet --list-sdks"] = "2.1.3 [C:\\Program Files\\dotnet\\sdks]\n2.1.4 [C:\\Program Files\\dotnet\\sdks]";
            Actions.RunProcess[@"cmd.exe /C powershell -NoProfile -ExecutionPolicy unrestricted -file C:\Project\install-dotnet.ps1 -Version 2.1.3 -InstallDir C:\Project\.dotnet"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\Project\.dotnet\dotnet --info"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\Project\.dotnet\dotnet clean"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\Project\.dotnet\dotnet restore"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --auto C:\Project\.dotnet\dotnet build --no-incremental /p:UseSharedCompilation=false"] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\java\bin\java -jar C:\odasa\tools\extractor-asp.jar ."] = 0;
            Actions.RunProcess[@"cmd.exe /C C:\odasa\tools\odasa index --xml --extensions config csproj props xml"] = 0;
            Actions.FileExists["csharp.log"] = true;
            Actions.GetEnvironmentVariable["TRAP_FOLDER"] = null;
            Actions.GetEnvironmentVariable["SOURCE_ARCHIVE"] = null;
            Actions.GetEnvironmentVariable["PATH"] = "/bin:/usr/bin";
            Actions.EnumerateFiles[@"C:\Project"] = "foo.cs\ntest.cs";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder("csharp", true, dotnetVersion: "2.1.3");
            TestAutobuilderScript(autobuilder, 0, 8);
        }
    }
}
