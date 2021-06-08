using Xunit;
using Semmle.Autobuild.Shared;
using System.Collections.Generic;
using System;
using System.Linq;
using Microsoft.Build.Construction;
using System.Xml;
using System.IO;

namespace Semmle.Autobuild.Cpp.Tests
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
        public HashSet<string> CreateDirectories { get; } = new HashSet<string>();
        public HashSet<(string, string)> DownloadFiles { get; } = new HashSet<(string, string)>();

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

        public IDictionary<string, string?> GetEnvironmentVariable = new Dictionary<string, string?>();

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
            return string.Join(IsWindows ? '\\' : '/', parts.Where(p => !string.IsNullOrWhiteSpace(p)));
        }

        string IBuildActions.GetFullPath(string path) => path;

        string? IBuildActions.GetFileName(string? path) => Path.GetFileName(path?.Replace('\\', '/'));

        public string? GetDirectoryName(string? path)
        {
            var dir = Path.GetDirectoryName(path?.Replace('\\', '/'));
            return dir is null ? path : path?.Substring(0, dir.Length);
        }

        void IBuildActions.WriteAllText(string filename, string contents)
        {
        }

        public IDictionary<string, XmlDocument> LoadXml = new Dictionary<string, XmlDocument>();
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

        public void CreateDirectory(string path)
        {
            if (!CreateDirectories.Contains(path))
                throw new ArgumentException($"Missing CreateDirectory, {path}");
        }

        public void DownloadFile(string address, string fileName)
        {
            if (!DownloadFiles.Contains((address, fileName)))
                throw new ArgumentException($"Missing DownloadFile, {address}, {fileName}");
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
        TestActions Actions = new TestActions();

        // Records the arguments passed to StartCallback.
        IList<string> StartCallbackIn = new List<string>();

        void StartCallback(string s, bool silent)
        {
            StartCallbackIn.Add(s);
        }

        // Records the arguments passed to EndCallback
        IList<string> EndCallbackIn = new List<string>();
        IList<int> EndCallbackReturn = new List<int>();

        void EndCallback(int ret, string s, bool silent)
        {
            EndCallbackReturn.Add(ret);
            EndCallbackIn.Add(s);
        }

        CppAutobuilder CreateAutoBuilder(bool isWindows,
            string? buildless = null, string? solution = null, string? buildCommand = null, string? ignoreErrors = null,
            string? msBuildArguments = null, string? msBuildPlatform = null, string? msBuildConfiguration = null, string? msBuildTarget = null,
            string? dotnetArguments = null, string? dotnetVersion = null, string? vsToolsVersion = null,
            string? nugetRestore = null, string? allSolutions = null,
            string cwd = @"C:\Project")
        {
            string codeqlUpperLanguage = Language.Cpp.UpperCaseName;
            Actions.GetEnvironmentVariable[$"CODEQL_AUTOBUILDER_{codeqlUpperLanguage}_NO_INDEXING"] = "false";
            Actions.GetEnvironmentVariable[$"CODEQL_EXTRACTOR_{codeqlUpperLanguage}_TRAP_DIR"] = "";
            Actions.GetEnvironmentVariable[$"CODEQL_EXTRACTOR_{codeqlUpperLanguage}_SOURCE_ARCHIVE_DIR"] = "";
            Actions.GetEnvironmentVariable[$"CODEQL_EXTRACTOR_{codeqlUpperLanguage}_ROOT"] = $@"C:\codeql\{codeqlUpperLanguage.ToLowerInvariant()}";
            Actions.GetEnvironmentVariable["CODEQL_JAVA_HOME"] = @"C:\codeql\tools\java";
            Actions.GetEnvironmentVariable["CODEQL_PLATFORM"] = "win64";
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

            var options = new AutobuildOptions(Actions, Language.Cpp);
            return new CppAutobuilder(Actions, options);
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
        public void TestDefaultCppAutobuilder()
        {
            Actions.EnumerateFiles[@"C:\Project"] = "";
            Actions.EnumerateDirectories[@"C:\Project"] = "";

            var autobuilder = CreateAutoBuilder(true);
            var script = autobuilder.GetBuildScript();

            // Fails due to no solutions present.
            Assert.NotEqual(0, script.Run(Actions, StartCallback, EndCallback));
        }

        [Fact]
        public void TestCppAutobuilderSuccess()
        {
            Actions.RunProcess[@"cmd.exe /C nuget restore C:\Project\test.sln -DisableParallelProcessing"] = 1;
            Actions.RunProcess[@"cmd.exe /C C:\Project\.nuget\nuget.exe restore C:\Project\test.sln -DisableParallelProcessing"] = 0;
            Actions.RunProcess[@"cmd.exe /C CALL ^""C:\Program Files ^(x86^)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat^"" && set Platform=&& type NUL && C:\odasa\tools\odasa index --auto msbuild C:\Project\test.sln /p:UseSharedCompilation=false /t:rebuild /p:Platform=""x86"" /p:Configuration=""Release"" /p:MvcBuildViews=true"] = 0;
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
            Actions.CreateDirectories.Add(@"C:\Project\.nuget");
            Actions.DownloadFiles.Add(("https://dist.nuget.org/win-x86-commandline/latest/nuget.exe", @"C:\Project\.nuget\nuget.exe"));

            var autobuilder = CreateAutoBuilder(true);
            var solution = new TestSolution(@"C:\Project\test.sln");
            autobuilder.ProjectsOrSolutionsToBuild.Add(solution);
            TestAutobuilderScript(autobuilder, 0, 3);
        }
    }
}
