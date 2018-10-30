using Semmle.Extraction.CSharp;
using Semmle.Util.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Autobuild
{
    /// <summary>
    /// A build rule analyses the files in "builder" and outputs a build script.
    /// </summary>
    interface IBuildRule
    {
        /// <summary>
        /// Analyse the files and produce a build script.
        /// </summary>
        /// <param name="builder">The files and options relating to the build.</param>
        BuildScript Analyse(Autobuilder builder);
    }

    /// <summary>
    /// Main application logic, containing all data
    /// gathered from the project and filesystem.
    ///
    /// The overall design is intended to be extensible so that in theory,
    /// it should be possible to add new build rules without touching this code.
    /// </summary>
    public class Autobuilder
    {
        /// <summary>
        /// Full file paths of files found in the project directory.
        /// </summary>
        public IEnumerable<string> Paths => pathsLazy.Value;
        readonly Lazy<IEnumerable<string>> pathsLazy;

        /// <summary>
        /// Gets a list of paths matching a set of extensions
        /// (including the ".").
        /// </summary>
        /// <param name="extensions">The extensions to find.</param>
        /// <returns>The files matching the extension.</returns>
        public IEnumerable<string> GetExtensions(params string[] extensions) =>
            Paths.Where(p => extensions.Contains(Path.GetExtension(p)));

        /// <summary>
        /// Gets all paths matching a particular filename.
        /// </summary>
        /// <param name="name">The filename to find.</param>
        /// <returns>Possibly empty sequence of paths with the given filename.</returns>
        public IEnumerable<string> GetFilename(string name) => Paths.Where(p => Path.GetFileName(p) == name);

        /// <summary>
        /// Holds if a given path, relative to the root of the source directory
        /// was found.
        /// </summary>
        /// <param name="path">The relative path.</param>
        /// <returns>True iff the path was found.</returns>
        public bool HasRelativePath(string path) => HasPath(Actions.PathCombine(RootDirectory, path));

        /// <summary>
        /// List of solution files to build.
        /// </summary>
        public IList<ISolution> SolutionsToBuild => solutionsToBuildLazy.Value;
        readonly Lazy<IList<ISolution>> solutionsToBuildLazy;

        /// <summary>
        /// Holds if a given path was found.
        /// </summary>
        /// <param name="path">The path of the file.</param>
        /// <returns>True iff the path was found.</returns>
        public bool HasPath(string path) => Paths.Any(p => path == p);

        void FindFiles(string dir, int depth, IList<string> results)
        {
            foreach (var f in Actions.EnumerateFiles(dir))
            {
                results.Add(f);
            }

            if (depth > 1)
            {
                foreach (var d in Actions.EnumerateDirectories(dir))
                {
                    FindFiles(d, depth - 1, results);
                }
            }
        }

        /// <summary>
        /// The root of the source directory.
        /// </summary>
        string RootDirectory => Options.RootDirectory;

        /// <summary>
        /// Gets the supplied build configuration.
        /// </summary>
        public AutobuildOptions Options { get; }

        /// <summary>
        /// The set of build actions used during the autobuilder.
        /// Could be real system operations, or a stub for testing.
        /// </summary>
        public IBuildActions Actions { get; }

        /// <summary>
        /// Find all the relevant files and picks the best
        /// solution file and tools.
        /// </summary>
        /// <param name="options">The command line options.</param>
        public Autobuilder(IBuildActions actions, AutobuildOptions options)
        {
            Actions = actions;
            Options = options;

            pathsLazy = new Lazy<IEnumerable<string>>(() =>
            {
                var files = new List<string>();
                FindFiles(options.RootDirectory, options.SearchDepth, files);
                return files.
                    OrderBy(s => s.Count(c => c == Path.DirectorySeparatorChar)).
                    ThenBy(s => Path.GetFileName(s).Length).
                    ToArray();
            });

            solutionsToBuildLazy = new Lazy<IList<ISolution>>(() =>
            {
                if (options.Solution.Any())
                {
                    var ret = new List<ISolution>();
                    foreach (var solution in options.Solution)
                    {
                        if (actions.FileExists(solution))
                            ret.Add(new Solution(this, solution));
                        else
                            Log(Severity.Error, "The specified solution file {0} was not found", solution);
                    }
                    return ret;
                }

                var solutions = GetExtensions(".sln").
                        Select(s => new Solution(this, s)).
                        Where(s => s.ProjectCount > 0).
                        OrderByDescending(s => s.ProjectCount).
                        ThenBy(s => s.Path.Length).
                        ToArray();

                foreach (var sln in solutions)
                {
                    Log(Severity.Info, $"Found {sln.Path} with {sln.ProjectCount} {this.Options.Language} projects, version {sln.ToolsVersion}, config {string.Join(" ", sln.Configurations.Select(c => c.FullName))}");
                }

                return new List<ISolution>(options.AllSolutions ?
                    solutions :
                    solutions.Take(1));
            });

            SemmleDist = Actions.GetEnvironmentVariable("SEMMLE_DIST");

            SemmleJavaHome = Actions.GetEnvironmentVariable("SEMMLE_JAVA_HOME");

            SemmlePlatformTools = Actions.GetEnvironmentVariable("SEMMLE_PLATFORM_TOOLS");

            if (SemmleDist == null)
                Log(Severity.Error, "The environment variable SEMMLE_DIST has not been set.");
        }

        readonly ILogger logger = new ConsoleLogger(Verbosity.Info);

        /// <summary>
        /// Log a given build event to the console.
        /// </summary>
        /// <param name="format">The format string.</param>
        /// <param name="args">Inserts to the format string.</param>
        public void Log(Severity severity, string format, params object[] args)
        {
            logger.Log(severity, format, args);
        }

        /// <summary>
        /// Attempt to build this project.
        /// </summary>
        /// <returns>The exit code, 0 for success and non-zero for failures.</returns>
        public int AttemptBuild()
        {
            Log(Severity.Info, $"Working directory: {Options.RootDirectory}");

            var script = GetBuildScript();
            if (Options.IgnoreErrors)
                script |= BuildScript.Success;

            void startCallback(string s) => Log(Severity.Info, $"\nRunning {s}");
            void exitCallback(int ret, string msg) => Log(Severity.Info, $"Exit code {ret}{(string.IsNullOrEmpty(msg) ? "" : $": {msg}")}");
            return script.Run(Actions, startCallback, exitCallback);
        }

        /// <summary>
        /// Returns the build script to use for this project.
        /// </summary>
        public BuildScript GetBuildScript()
        {
            var isCSharp = Options.Language == Language.CSharp;
            return isCSharp ? GetCSharpBuildScript() : GetCppBuildScript();
        }

        BuildScript GetCSharpBuildScript()
        {
            /// <summary>
            /// A script that checks that the C# extractor has been executed.
            /// </summary>
            BuildScript CheckExtractorRun(bool warnOnFailure) =>
                BuildScript.Create(actions =>
                {
                    if (actions.FileExists(Extractor.GetCSharpLogPath()))
                        return 0;

                    if (warnOnFailure)
                        Log(Severity.Error, "No C# code detected during build.");

                    return 1;
                });

            var attempt = BuildScript.Failure;
            switch (GetCSharpBuildStrategy())
            {
                case CSharpBuildStrategy.CustomBuildCommand:
                    attempt = new BuildCommandRule().Analyse(this) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.Buildless:
                    // No need to check that the extractor has been executed in buildless mode
                    attempt = new StandaloneBuildRule().Analyse(this);
                    break;
                case CSharpBuildStrategy.MSBuild:
                    attempt = new MsBuildRule().Analyse(this) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.DotNet:
                    attempt = new DotNetRule().Analyse(this) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.Auto:
                    var cleanTrapFolder =
                        BuildScript.DeleteDirectory(Actions.GetEnvironmentVariable("TRAP_FOLDER"));
                    var cleanSourceArchive =
                        BuildScript.DeleteDirectory(Actions.GetEnvironmentVariable("SOURCE_ARCHIVE"));
                    var cleanExtractorLog =
                        BuildScript.DeleteFile(Extractor.GetCSharpLogPath());
                    var attemptExtractorCleanup =
                        BuildScript.Try(cleanTrapFolder) &
                        BuildScript.Try(cleanSourceArchive) &
                        BuildScript.Try(cleanExtractorLog);

                    /// <summary>
                    /// Execute script `s` and check that the C# extractor has been executed.
                    /// If either fails, attempt to cleanup any artifacts produced by the extractor,
                    /// and exit with code 1, in order to proceed to the next attempt.
                    /// </summary>
                    BuildScript IntermediateAttempt(BuildScript s) =>
                        (s & CheckExtractorRun(false)) |
                        (attemptExtractorCleanup & BuildScript.Failure);

                    attempt =
                        // First try .NET Core
                        IntermediateAttempt(new DotNetRule().Analyse(this)) |
                        // Then MSBuild
                        (() => IntermediateAttempt(new MsBuildRule().Analyse(this))) |
                        // And finally look for a script that might be a build script
                        (() => new BuildCommandAutoRule().Analyse(this) & CheckExtractorRun(true)) |
                        // All attempts failed: print message
                        AutobuildFailure();
                    break;
            }

            return
                attempt &
                (() => new AspBuildRule().Analyse(this)) &
                (() => new XmlBuildRule().Analyse(this));
        }

        /// <summary>
        /// Gets the build strategy that the autobuilder should apply, based on the
        /// options in the `lgtm.yml` file.
        /// </summary>
        CSharpBuildStrategy GetCSharpBuildStrategy()
        {
            if (Options.BuildCommand != null)
                return CSharpBuildStrategy.CustomBuildCommand;

            if (Options.Buildless)
                return CSharpBuildStrategy.Buildless;

            if (Options.MsBuildArguments != null
                || Options.MsBuildConfiguration != null
                || Options.MsBuildPlatform != null
                || Options.MsBuildTarget != null)
                return CSharpBuildStrategy.MSBuild;

            if (Options.DotNetArguments != null || Options.DotNetVersion != null)
                return CSharpBuildStrategy.DotNet;

            return CSharpBuildStrategy.Auto;
        }

        enum CSharpBuildStrategy
        {
            CustomBuildCommand,
            Buildless,
            MSBuild,
            DotNet,
            Auto
        }

        BuildScript GetCppBuildScript()
        {
            if (Options.BuildCommand != null)
                return new BuildCommandRule().Analyse(this);

            return
                // First try MSBuild
                new MsBuildRule().Analyse(this) |
                // Then look for a script that might be a build script
                (() => new BuildCommandAutoRule().Analyse(this)) |
                // All attempts failed: print message
                AutobuildFailure();
        }

        BuildScript AutobuildFailure() =>
            BuildScript.Create(actions =>
                {
                    Log(Severity.Error, "Could not auto-detect a suitable build method");
                    return 1;
                });

        /// <summary>
        /// Value of SEMMLE_DIST environment variable.
        /// </summary>
        public string SemmleDist { get; private set; }

        /// <summary>
        /// Value of SEMMLE_JAVA_HOME environment variable.
        /// </summary>
        public string SemmleJavaHome { get; private set; }

        /// <summary>
        /// Value of SEMMLE_PLATFORM_TOOLS environment variable.
        /// </summary>
        public string SemmlePlatformTools { get; private set; }

        /// <summary>
        /// The absolute path of the odasa executable.
        /// </summary>
        public string Odasa => SemmleDist == null ? null : Actions.PathCombine(SemmleDist, "tools", "odasa");
    }
}
