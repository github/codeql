using Semmle.Util.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// A build rule analyses the files in "builder" and outputs a build script.
    /// </summary>
    public interface IBuildRule
    {
        /// <summary>
        /// Analyse the files and produce a build script.
        /// </summary>
        /// <param name="builder">The files and options relating to the build.</param>
        /// <param name="auto">Whether this build rule is being automatically applied.</param>
        BuildScript Analyse(Autobuilder builder, bool auto);
    }

    /// <summary>
    /// A delegate used to wrap a build script in an environment where an appropriate
    /// version of .NET Core is automatically installed.
    /// </summary>
    public delegate BuildScript WithDotNet(Autobuilder builder, Func<IDictionary<string, string>?, BuildScript> f);

    /// <summary>
    /// Exception indicating that environment variables are missing or invalid.
    /// </summary>
    public class InvalidEnvironmentException : Exception
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
    public abstract class Autobuilder
    {
        /// <summary>
        /// Full file paths of files found in the project directory, as well as
        /// their distance from the project root folder. The list is sorted
        /// by distance in ascending order.
        /// </summary>
        public IEnumerable<(string, int)> Paths => pathsLazy.Value;
        private readonly Lazy<IEnumerable<(string, int)>> pathsLazy;

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
            Paths.Where(p => Actions.GetFileName(p.Item1) == name);

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

        private void FindFiles(string dir, int depth, int maxDepth, IList<(string, int)> results)
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
        private string RootDirectory => Options.RootDirectory;

        /// <summary>
        /// Gets the supplied build configuration.
        /// </summary>
        public AutobuildOptions Options { get; }

        /// <summary>
        /// The set of build actions used during the autobuilder.
        /// Could be real system operations, or a stub for testing.
        /// </summary>
        public IBuildActions Actions { get; }

        private IEnumerable<IProjectOrSolution>? FindFiles(string extension, Func<string, ProjectOrSolution> create)
        {
            var matchingFiles = GetExtensions(extension)
                .Select(p => (ProjectOrSolution: create(p.Item1), DistanceFromRoot: p.Item2))
                .Where(p => p.ProjectOrSolution.HasLanguage(this.Options.Language))
                .ToArray();

            if (matchingFiles.Length == 0)
                return null;

            if (Options.AllSolutions)
                return matchingFiles.Select(p => p.ProjectOrSolution);

            return matchingFiles
                .Where(f => f.DistanceFromRoot == matchingFiles[0].DistanceFromRoot)
                .Select(f => f.ProjectOrSolution);
        }

        /// <summary>
        /// Find all the relevant files and picks the best
        /// solution file and tools.
        /// </summary>
        /// <param name="options">The command line options.</param>
        protected Autobuilder(IBuildActions actions, AutobuildOptions options)
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
            SemmlePlatformTools = Actions.GetEnvironmentVariable("SEMMLE_PLATFORM_TOOLS");

            CodeQlPlatform = Actions.GetEnvironmentVariable("CODEQL_PLATFORM");

            TrapDir =
                Actions.GetEnvironmentVariable($"CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_TRAP_DIR") ??
                Actions.GetEnvironmentVariable("TRAP_FOLDER") ??
                throw new InvalidEnvironmentException($"The environment variable CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_TRAP_DIR or TRAP_FOLDER has not been set.");

            SourceArchiveDir =
                Actions.GetEnvironmentVariable($"CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_SOURCE_ARCHIVE_DIR") ??
                Actions.GetEnvironmentVariable("SOURCE_ARCHIVE") ??
                throw new InvalidEnvironmentException($"The environment variable CODEQL_EXTRACTOR_{this.Options.Language.UpperCaseName}_SOURCE_ARCHIVE_DIR or SOURCE_ARCHIVE has not been set.");
        }

        protected string TrapDir { get; }

        protected string SourceArchiveDir { get; }

        private readonly ILogger logger = new ConsoleLogger(Verbosity.Info);

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
        public abstract BuildScript GetBuildScript();

        protected BuildScript AutobuildFailure() =>
            BuildScript.Create(actions =>
                {
                    Log(Severity.Error, "Could not auto-detect a suitable build method");
                    return 1;
                });

        /// <summary>
        /// Value of CODEQL_EXTRACTOR_<LANG>_ROOT environment variable.
        /// </summary>
        public string? CodeQLExtractorLangRoot { get; }

        /// <summary>
        /// Value of SEMMLE_PLATFORM_TOOLS environment variable.
        /// </summary>
        public string? SemmlePlatformTools { get; }

        /// <summary>
        /// Value of CODEQL_PLATFORM environment variable.
        /// </summary>
        public string? CodeQlPlatform { get; }

        /// <summary>
        /// The absolute path of the odasa executable.
        /// null if we are running in CodeQL.
        /// </summary>
        public string? Odasa
        {
            get
            {
                var semmleDist = Actions.GetEnvironmentVariable("SEMMLE_DIST");
                return semmleDist is null ? null : Actions.PathCombine(semmleDist, "tools", "odasa");
            }
        }

        /// <summary>
        /// Construct a command that executed the given <paramref name="cmd"/> wrapped in
        /// an <code>odasa --index</code>, unless indexing has been disabled, in which case
        /// <paramref name="cmd"/> is run directly.
        /// </summary>
        public CommandBuilder MaybeIndex(CommandBuilder builder, string cmd) => Odasa is null ? builder.RunCommand(cmd) : builder.IndexCommand(Odasa, cmd);
    }
}
