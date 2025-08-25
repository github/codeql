using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// A build rule analyses the files in "builder" and outputs a build script.
    /// </summary>
    public interface IBuildRule<TAutobuildOptions> where TAutobuildOptions : AutobuildOptionsShared
    {
        /// <summary>
        /// Analyse the files and produce a build script.
        /// </summary>
        /// <param name="builder">The files and options relating to the build.</param>
        /// <param name="auto">Whether this build rule is being automatically applied.</param>
        BuildScript Analyse(IAutobuilder<TAutobuildOptions> builder, bool auto);
    }

    /// <summary>
    /// A delegate used to wrap a build script in an environment where an appropriate
    /// version of .NET Core is automatically installed.
    /// </summary>
    public delegate BuildScript WithDotNet<TAutobuildOptions>(IAutobuilder<TAutobuildOptions> builder, Func<IDictionary<string, string>?, BuildScript> f) where TAutobuildOptions : AutobuildOptionsShared;

    /// <summary>
    /// Exception indicating that environment variables are missing or invalid.
    /// </summary>
    public class InvalidEnvironmentException : Exception
    {
        public InvalidEnvironmentException(string m) : base(m) { }
    }

    public interface IAutobuilder<out TAutobuildOptions> where TAutobuildOptions : AutobuildOptionsShared
    {
        /// <summary>
        /// Full file paths of files found in the project directory, as well as
        /// their distance from the project root folder. The list is sorted
        /// by distance in ascending order.
        /// </summary>
        IEnumerable<(string, int)> Paths { get; }

        /// <summary>
        /// Gets all paths matching a particular filename, as well as
        /// their distance from the project root folder. The list is sorted
        /// by distance in ascending order.
        /// </summary>
        /// <param name="name">The filename to find.</param>
        /// <returns>Possibly empty sequence of paths with the given filename.</returns>
        IEnumerable<(string, int)> GetFilename(string name) =>
           Paths.Where(p => Actions.GetFileName(p.Item1) == name);

        /// <summary>
        /// List of project/solution files to build.
        /// </summary>
        IList<IProjectOrSolution> ProjectsOrSolutionsToBuild { get; }

        /// <summary>
        /// Gets the supplied build configuration.
        /// </summary>
        TAutobuildOptions Options { get; }

        /// <summary>
        /// The set of build actions used during the autobuilder.
        /// Could be real system operations, or a stub for testing.
        /// </summary>
        IBuildActions Actions { get; }

        /// <summary>
        /// A logger.
        /// </summary>
        ILogger Logger { get; }
    }

    /// <summary>
    /// Main application logic, containing all data
    /// gathered from the project and filesystem.
    ///
    /// The overall design is intended to be extensible so that in theory,
    /// it should be possible to add new build rules without touching this code.
    /// </summary>
    public abstract class Autobuilder<TAutobuildOptions> : IDisposable, IAutobuilder<TAutobuildOptions> where TAutobuildOptions : AutobuildOptionsShared
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



        /// <summary>
        /// The root of the source directory.
        /// </summary>
        private string RootDirectory => Options.RootDirectory;

        /// <summary>
        /// Gets the supplied build configuration.
        /// </summary>
        public TAutobuildOptions Options { get; }

        /// <summary>
        /// The set of build actions used during the autobuilder.
        /// Could be real system operations, or a stub for testing.
        /// </summary>
        public IBuildActions Actions { get; }

        private IEnumerable<IProjectOrSolution>? FindFiles(string extension, Func<string, ProjectOrSolution<TAutobuildOptions>> create)
        {
            var matchingFiles = GetExtensions(extension)
                .Select(p => (ProjectOrSolution: create(p.Item1), DistanceFromRoot: p.Item2))
                .Where(p => p.ProjectOrSolution.HasLanguage(this.Options.Language))
                .ToArray();

            if (matchingFiles.Length == 0)
                return null;

            return matchingFiles
                .Where(f => f.DistanceFromRoot == matchingFiles[0].DistanceFromRoot)
                .Select(f => f.ProjectOrSolution);
        }

        /// <summary>
        /// Find all the relevant files and picks the best
        /// solution file and tools.
        /// </summary>
        /// <param name="options">The command line options.</param>
        protected Autobuilder(IBuildActions actions, TAutobuildOptions options, DiagnosticClassifier diagnosticClassifier)
        {
            Actions = actions;
            Options = options;
            DiagnosticClassifier = diagnosticClassifier;

            pathsLazy = new Lazy<IEnumerable<(string, int)>>(() => Actions.FindFiles(options.RootDirectory, options.SearchDepth));

            projectsOrSolutionsToBuildLazy = new Lazy<IList<IProjectOrSolution>>(() =>
            {
                List<IProjectOrSolution>? ret;
                // First look for `.proj` files
                ret = FindFiles(".proj", f => new Project<TAutobuildOptions>(this, f))?.ToList();
                if (ret is not null)
                    return ret;

                // Then look for `.sln` files
                ret = FindFiles(".sln", f => new Solution<TAutobuildOptions>(this, f, false))?.ToList();
                if (ret is not null)
                    return ret;

                // Finally look for language specific project files, e.g. `.csproj` files
                ret = FindFiles(this.Options.Language.ProjectExtension, f => new Project<TAutobuildOptions>(this, f))?.ToList();
                return ret ?? new List<IProjectOrSolution>();
            });

            TrapDir = RequireEnvironmentVariable(EnvVars.TrapDir(this.Options.Language));
            SourceArchiveDir = RequireEnvironmentVariable(EnvVars.SourceArchiveDir(this.Options.Language));
            DiagnosticsDir = RequireEnvironmentVariable(EnvVars.DiagnosticDir(this.Options.Language));

            this.diagnostics = actions.CreateDiagnosticsWriter(Path.Combine(DiagnosticsDir, $"autobuilder-{DateTime.UtcNow:yyyyMMddHHmm}-{Environment.ProcessId}.jsonc"));
        }

        /// <summary>
        /// Retrieves the value of an environment variable named <paramref name="name"/> or throws
        /// an exception if no such environment variable has been set.
        /// </summary>
        /// <param name="name">The name of the environment variable.</param>
        /// <returns>The value of the environment variable.</returns>
        /// <exception cref="InvalidEnvironmentException">
        /// Thrown if the environment variable is not set.
        /// </exception>
        protected string RequireEnvironmentVariable(string name)
        {
            return Actions.GetEnvironmentVariable(name) ??
                throw new InvalidEnvironmentException($"The environment variable {name} has not been set.");
        }

        public string TrapDir { get; }

        public string SourceArchiveDir { get; }

        public string DiagnosticsDir { get; }

        protected DiagnosticClassifier DiagnosticClassifier { get; }

        private readonly ILogger logger = new ConsoleLogger(
            VerbosityExtensions.ParseVerbosity(
                Environment.GetEnvironmentVariable("CODEQL_VERBOSITY"),
                logThreadId: false) ?? Verbosity.Info,
            logThreadId: false);

        public ILogger Logger => logger;

        private readonly IDiagnosticsWriter diagnostics;

        /// <summary>
        /// Makes <paramref name="path"/> relative to the root source directory.
        /// </summary>
        /// <param name="path">The path which to make relative.</param>
        /// <returns>The relative path.</returns>
        public string MakeRelative(string path)
        {
            return Path.GetRelativePath(this.RootDirectory, path);
        }

        /// <summary>
        /// Write <paramref name="diagnostic"/> to the diagnostics file.
        /// </summary>
        /// <param name="diagnostic">The diagnostics entry to write.</param>
        public void AddDiagnostic(DiagnosticMessage diagnostic)
        {
            diagnostics.AddEntry(diagnostic);
        }

        /// <summary>
        /// Attempt to build this project.
        /// </summary>
        /// <returns>The exit code, 0 for success and non-zero for failures.</returns>
        public int AttemptBuild()
        {
            logger.LogInfo($"Working directory: {Options.RootDirectory}");

            var script = GetBuildScript();

            void startCallback(string s, bool silent)
            {
                logger.Log(silent ? Severity.Debug : Severity.Info, $"\nRunning {s}");
            }

            void exitCallback(int ret, string msg, bool silent)
            {
                logger.Log(silent ? Severity.Debug : Severity.Info, $"Exit code {ret}{(string.IsNullOrEmpty(msg) ? "" : $": {msg}")}");
            }

            var onOutput = BuildOutputHandler(Console.Out);
            var onError = BuildOutputHandler(Console.Error);

            var buildResult = script.Run(Actions, startCallback, exitCallback, onOutput, onError);

            // if the build succeeded, all diagnostics we captured from the build output should be warnings;
            // otherwise they should all be errors
            var diagSeverity = buildResult == 0 ? DiagnosticMessage.TspSeverity.Warning : DiagnosticMessage.TspSeverity.Error;
            this.DiagnosticClassifier.Results
                .Select(result => result.ToDiagnosticMessage(this, diagSeverity))
                .ForEach(AddDiagnostic);

            return buildResult;
        }

        /// <summary>
        /// Returns the build script to use for this project.
        /// </summary>
        public abstract BuildScript GetBuildScript();


        /// <summary>
        /// Produces a diagnostic for the tool status page that we were unable to automatically
        /// build the user's project and that they can manually specify a build command. This
        /// can be overriden to implement more specific messages depending on the origin of
        /// the failure.
        /// </summary>
        protected virtual void AutobuildFailureDiagnostic() => AddDiagnostic(new DiagnosticMessage(
                this.Options.Language,
                "autobuild-failure",
                "Unable to build project",
                visibility: new DiagnosticMessage.TspVisibility(statusPage: true),
                plaintextMessage: """
                    We were unable to automatically build your project.
                    Set up a manual build command.
                """
            ));

        /// <summary>
        /// Returns a build script that can be run upon autobuild failure.
        /// </summary>
        /// <returns>
        /// A build script that reports that we could not automatically detect a suitable build method.
        /// </returns>
        protected BuildScript AutobuildFailure() =>
            BuildScript.Create(actions =>
                {
                    logger.LogError("Could not auto-detect a suitable build method");

                    AutobuildFailureDiagnostic();

                    return 1;
                });

        /// <summary>
        /// Constructs a <see cref="BuildOutputHandler" /> which uses the <see cref="DiagnosticClassifier" />
        /// to classify build output. All data also gets written to <paramref name="writer" />.
        /// </summary>
        /// <param name="writer">
        /// The <see cref="TextWriter" /> to which the build output would have normally been written to.
        /// This is normally <see cref="Console.Out" /> or <see cref="Console.Error" />.
        /// </param>
        /// <returns>The constructed <see cref="BuildOutputHandler" />.</returns>
        protected BuildOutputHandler BuildOutputHandler(TextWriter writer) => new(data =>
        {
            if (data is not null)
            {
                writer.WriteLine(data);
                DiagnosticClassifier.ClassifyLine(data);
            }
        });

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                diagnostics.Dispose();
            }
        }
    }
}
