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
        /// <param name="auto">Whether this build rule is being automatically applied.</param>
        BuildScript Analyse(Autobuilder builder, bool auto);
    }

    /// <summary>
    /// Exception indicating that environment variables are missing or invalid.
    /// </summary>
    class InvalidEnvironmentException : Exception
    {
        public InvalidEnvironmentException(string m) : base(m) { }
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
        /// Full file paths of files found in the project directory, as well as
        /// their distance from the project root folder. The list is sorted
        /// by distance in ascending order.
        /// </summary>
        public IEnumerable<(string, int)> Paths => pathsLazy.Value;
        readonly Lazy<IEnumerable<(string, int)>> pathsLazy;

        /// <summary>
        /// Gets a list of paths matching a set of extensions (including the "."),
        /// as well as their distance from the project root folder.
        /// The list is sorted by distance in ascending order.
        /// </summary>
        /// <param name="extensions">The extensions to find.</param>
        /// <returns>The files matching the extension.</returns>
        public IEnumerable<(string, int)> GetExtensions(params string[] extensions) =>
            Paths.Where(p => extensions.Contains(Path.GetExtension(p.Item1)));

        /// <summary>
        /// Gets all paths matching a particular filename, as well as
        /// their distance from the project root folder. The list is sorted
        /// by distance in ascending order.
        /// </summary>
        /// <param name="name">The filename to find.</param>
        /// <returns>Possibly empty sequence of paths with the given filename.</returns>
        public IEnumerable<(string, int)> GetFilename(string name) =>
            Paths.Where(p => Path.GetFileName(p.Item1) == name);

        /// <summary>
        /// Holds if a given path, relative to the root of the source directory
        /// was found.
        /// </summary>
        /// <param name="path">The relative path.</param>
        /// <returns>True iff the path was found.</returns>
        public bool HasRelativePath(string path) => HasPath(Actions.PathCombine(RootDirectory, path));

        /// <summary>
        /// List of project/solution files to build.
        /// </summary>
        public IList<IProjectOrSolution> ProjectsOrSolutionsToBuild => projectsOrSolutionsToBuildLazy.Value;
        private readonly Lazy<IList<IProjectOrSolution>> projectsOrSolutionsToBuildLazy;

        /// <summary>
        /// Holds if a given path was found.
        /// </summary>
        /// <param name="path">The path of the file.</param>
        /// <returns>True iff the path was found.</returns>
        public bool HasPath(string path) => Paths.Any(p => path == p.Item1);

        void FindFiles(string dir, int depth, int maxDepth, IList<(string, int)> results)
        {
            foreach (var f in Actions.EnumerateFiles(dir))
            {
                results.Add((f, depth));
            }

            if (depth < maxDepth)
            {
                foreach (var d in Actions.EnumerateDirectories(dir))
                {
                    FindFiles(d, depth + 1, maxDepth, results);
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

        IEnumerable<IProjectOrSolution>? FindFiles(string extension, Func<string, ProjectOrSolution> create)
        {
            var matchingFiles = GetExtensions(extension).
                Select(p => (ProjectOrSolution: create(p.Item1), DistanceFromRoot: p.Item2)).
                Where(p => p.ProjectOrSolution.HasLanguage(this.Options.Language)).
                ToArray();

            if (matchingFiles.Length == 0)
               return null;

            if (Options.AllSolutions)
               return matchingFiles.Select(p => p.ProjectOrSolution);

            return matchingFiles.
                Where(f => f.DistanceFromRoot == matchingFiles[0].DistanceFromRoot).
                Select(f => f.ProjectOrSolution);
        }

        /// <summary>
        /// Find all the relevant files and picks the best
        /// solution file and tools.
        /// </summary>
        /// <param name="options">The command line options.</param>
        public Autobuilder(IBuildActions actions, AutobuildOptions options)
        {
            Actions = actions;
            Options = options;

            pathsLazy = new Lazy<IEnumerable<(string, int)>>(() =>
            {
                var files = new List<(string, int)>();
                FindFiles(options.RootDirectory, 0, options.SearchDepth, files);
                return files.OrderBy(f => f.Item2).ToArray();
            });

            projectsOrSolutionsToBuildLazy = new Lazy<IList<IProjectOrSolution>>(() =>
            {
                List<IProjectOrSolution>? ret;
                if (options.Solution.Any())
                {
                    ret = new List<IProjectOrSolution>();
                    foreach (var solution in options.Solution)
                    {
                        if (actions.FileExists(solution))
                            ret.Add(new Solution(this, solution, true));
                        else
                            Log(Severity.Error, $"The specified project or solution file {solution} was not found");
                    }
                    return ret;
                }

                // First look for `.proj` files
                ret = FindFiles(".proj", f => new Project(this, f))?.ToList();
                if (ret != null)
                    return ret;

                // Then look for `.sln` files
                ret = FindFiles(".sln", f => new Solution(this, f, false))?.ToList();
                if (ret != null)
                    return ret;

                // Finally look for language specific project files, e.g. `.csproj` files
                ret = FindFiles(this.Options.Language.ProjectExtension, f => new Project(this, f))?.ToList();
                return ret ?? new List<IProjectOrSolution>();
            });

            CodeQLExtractorLangRoot = Actions.GetEnvironmentVariable($"CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_ROOT");
            SemmleDist = Actions.GetEnvironmentVariable("SEMMLE_DIST");
            SemmlePlatformTools = Actions.GetEnvironmentVariable("SEMMLE_PLATFORM_TOOLS");

            JavaHome = 
                Actions.GetEnvironmentVariable("CODEQL_JAVA_HOME") ??
                Actions.GetEnvironmentVariable("SEMMLE_JAVA_HOME") ?? 
                throw new InvalidEnvironmentException("The environment variable CODEQL_JAVA_HOME or SEMMLE_JAVA_HOME has not been set.");

            Distribution =
                CodeQLExtractorLangRoot ??
                SemmleDist ??
                throw new InvalidEnvironmentException($"The environment variable CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_ROOT or SEMMLE_DIST has not been set.");

            TrapDir =
                Actions.GetEnvironmentVariable($"CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_TRAP_DIR") ??
                Actions.GetEnvironmentVariable("TRAP_FOLDER") ??
                throw new InvalidEnvironmentException($"The environment variable CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_TRAP_DIR or TRAP_FOLDER has not been set.");

            SourceArchiveDir =
                Actions.GetEnvironmentVariable($"CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_SOURCE_ARCHIVE_DIR") ??
                Actions.GetEnvironmentVariable("SOURCE_ARCHIVE") ??
                throw new InvalidEnvironmentException($"The environment variable CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_SOURCE_ARCHIVE_DIR or SOURCE_ARCHIVE has not been set.");
        }

        private string TrapDir { get; }

        private string SourceArchiveDir { get; }

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

            void startCallback(string s, bool silent)
            {
                Log(silent ? Severity.Debug : Severity.Info, $"\nRunning {s}");
            }

            void exitCallback(int ret, string msg, bool silent)
            {
                Log(silent ? Severity.Debug : Severity.Info, $"Exit code {ret}{(string.IsNullOrEmpty(msg) ? "" : $": {msg}")}");
            }

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
                    attempt = new BuildCommandRule().Analyse(this, false) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.Buildless:
                    // No need to check that the extractor has been executed in buildless mode
                    attempt = new StandaloneBuildRule().Analyse(this, false);
                    break;
                case CSharpBuildStrategy.MSBuild:
                    attempt = new MsBuildRule().Analyse(this, false) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.DotNet:
                    attempt = new DotNetRule().Analyse(this, false) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.Auto:
                    var cleanTrapFolder =
                        BuildScript.DeleteDirectory(TrapDir);
                    var cleanSourceArchive =
                        BuildScript.DeleteDirectory(SourceArchiveDir);
                    var tryCleanExtractorArgsLogs =
                        BuildScript.Create(actions =>
                        {
                            foreach (var file in Extractor.GetCSharpArgsLogs())
                                try
                                {
                                    actions.FileDelete(file);
                                }
                                catch // lgtm[cs/catch-of-all-exceptions] lgtm[cs/empty-catch-block]
                                { }
                            return 0;
                        });
                    var attemptExtractorCleanup =
                        BuildScript.Try(cleanTrapFolder) &
                        BuildScript.Try(cleanSourceArchive) &
                        tryCleanExtractorArgsLogs &
                        BuildScript.DeleteFile(Extractor.GetCSharpLogPath());

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
                        IntermediateAttempt(new DotNetRule().Analyse(this, true)) |
                        // Then MSBuild
                        (() => IntermediateAttempt(new MsBuildRule().Analyse(this, true))) |
                        // And finally look for a script that might be a build script
                        (() => new BuildCommandAutoRule().Analyse(this, true) & CheckExtractorRun(true)) |
                        // All attempts failed: print message
                        AutobuildFailure();
                    break;
            }

            return
                attempt &
                (() => new AspBuildRule().Analyse(this, false)) &
                (() => new XmlBuildRule().Analyse(this, false));
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
                return new BuildCommandRule().Analyse(this, false);

            return
                // First try MSBuild
                new MsBuildRule().Analyse(this, true) |
                // Then look for a script that might be a build script
                (() => new BuildCommandAutoRule().Analyse(this, true)) |
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
        /// Value of CODEQL_EXTRACTOR_<LANG>_ROOT environment variable.
        /// </summary>
        private string? CodeQLExtractorLangRoot { get; }

        /// <summary>
        /// Value of SEMMLE_DIST environment variable.
        /// </summary>
        private string? SemmleDist { get; }

        public string Distribution { get; }

        public string JavaHome { get; }

        /// <summary>
        /// Value of SEMMLE_PLATFORM_TOOLS environment variable.
        /// </summary>
        public string? SemmlePlatformTools { get; }

        /// <summary>
        /// The absolute path of the odasa executable.
        /// null if we are running in CodeQL.
        /// </summary>
        public string? Odasa => SemmleDist is null ? null : Actions.PathCombine(SemmleDist, "tools", "odasa");

        /// <summary>
        /// Construct a command that executed the given <paramref name="cmd"/> wrapped in
        /// an <code>odasa --index</code>, unless indexing has been disabled, in which case
        /// <paramref name="cmd"/> is run directly.
        /// </summary>
        internal CommandBuilder MaybeIndex(CommandBuilder builder, string cmd) => Options.Indexing && !(Odasa is null) ? builder.IndexCommand(Odasa, cmd) : builder.RunCommand(cmd);
    }
}
