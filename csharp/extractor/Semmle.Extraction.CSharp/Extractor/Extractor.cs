using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Basic.CompilerLog.Util;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.Text;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    public enum ExitCode
    {
        Ok,         // Everything worked perfectly
        Errors,     // Trap was generated but there were processing errors
        Failed      // Trap could not be generated
    }

    public static class Extractor
    {
        private class LogProgressMonitor : IProgressMonitor
        {
            private readonly ILogger logger;

            public LogProgressMonitor(ILogger logger)
            {
                this.logger = logger;
            }

            public void Analysed(int item, int total, string source, string output, TimeSpan time, AnalysisAction action)
            {
                if (action != AnalysisAction.UpToDate)
                {
                    var state = action == AnalysisAction.Extracted
                        ? time.ToString()
                        : action == AnalysisAction.Excluded
                            ? "excluded"
                            : "up to date";
                    logger.LogInfo($"  {source} ({state})");
                }
            }

            public void Started(int item, int total, string source) { }

            public void MissingNamespace(string @namespace) { }

            public void MissingSummary(int types, int namespaces) { }

            public void MissingType(string type) { }
        }

        /// <summary>
        /// Set the application culture to the invariant culture.
        ///
        /// This is required among others to ensure that the invariant culture is used for value formatting during TRAP
        /// file writing.
        /// </summary>
        public static void SetInvariantCulture()
        {
            var culture = CultureInfo.InvariantCulture;
            CultureInfo.DefaultThreadCurrentCulture = culture;
            CultureInfo.DefaultThreadCurrentUICulture = culture;
            Thread.CurrentThread.CurrentCulture = culture;
            Thread.CurrentThread.CurrentUICulture = culture;
        }

        public static ILogger MakeLogger(Verbosity verbosity, bool includeConsole)
        {
            var fileLogger = new FileLogger(verbosity, GetCSharpLogPath(), logThreadId: true);
            return includeConsole
                ? new CombinedLogger(new ConsoleLogger(verbosity, logThreadId: true), fileLogger)
                : (ILogger)fileLogger;
        }

        /// <summary>
        /// Command-line driver for the extractor.
        /// </summary>
        ///
        /// <remarks>
        /// The extractor can be invoked in one of two ways: Either as an "analyser" passed in via the /a
        /// option to csc.exe, or as a stand-alone executable. In this case, we need to faithfully
        /// drive Roslyn in the way that csc.exe would.
        /// </remarks>
        ///
        /// <param name="args">Command line arguments as passed to csc.exe</param>
        /// <returns><see cref="ExitCode"/></returns>
        public static ExitCode Run(string[] args)
        {
            var analyzerStopwatch = new Stopwatch();
            analyzerStopwatch.Start();

            var options = Options.CreateWithEnvironment(args);

            using var logger = MakeLogger(options.Verbosity, options.Console);

            try
            {
                var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
                var pathTransformer = new PathTransformer(canonicalPathCache);

                if (options.BinaryLogPath is string binlogPath)
                {
                    logger.LogInfo(" Running binary log analysis.");
                    return RunBinaryLogAnalysis(analyzerStopwatch, options, binlogPath, logger, canonicalPathCache, pathTransformer);
                }
                else
                {
                    logger.LogInfo(" Running tracing analysis.");
                    return RunTracingAnalysis(analyzerStopwatch, options, logger, canonicalPathCache, pathTransformer);
                }
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                logger.LogError($"  Unhandled exception: {ex}");
                return ExitCode.Errors;
            }
        }

        private static ExitCode RunBinaryLogAnalysis(Stopwatch stopwatch, Options options, string binlogPath, ILogger logger, CanonicalPathCache canonicalPathCache, PathTransformer pathTransformer)
        {
            logger.LogInfo($"Reading compiler calls from binary log {binlogPath}");
            try
            {
                using var fileStream = new FileStream(binlogPath, FileMode.Open, FileAccess.Read, FileShare.Read);
                using var reader = BinaryLogReader.Create(fileStream);

                // Filter out compiler calls that aren't interesting for examination
                static bool filter(CompilerCall compilerCall)
                {
                    return compilerCall.IsCSharp &&
                        compilerCall.Kind == CompilerCallKind.Regular;
                }

                var allCompilationData = reader.ReadAllCompilationData(filter);
                var allFailed = true;

                logger.LogInfo($"  Found {allCompilationData.Count} compilations in binary log");

                foreach (var compilationData in allCompilationData)
                {
                    if (compilationData.GetCompilationAfterGenerators() is not CSharpCompilation compilation)
                    {
                        logger.LogError("  Compilation data is not C#");
                        continue;
                    }

                    var compilerCall = compilationData.CompilerCall;
                    var diagnosticName = compilerCall.GetDiagnosticName();
                    logger.LogInfo($"  Processing compilation {diagnosticName} at {compilerCall.ProjectDirectory}");
                    var compilerArgs = compilerCall.GetArguments();

                    var compilationIdentifierPath = string.Empty;
                    try
                    {
                        compilationIdentifierPath = FileUtils.ConvertPathToSafeRelativePath(
                            Path.GetRelativePath(Directory.GetCurrentDirectory(), compilerCall.ProjectDirectory));
                    }
                    catch (ArgumentException exc)
                    {
                        logger.LogWarning($"  Failed to get relative path for {compilerCall.ProjectDirectory} from current working directory {Directory.GetCurrentDirectory()}: {exc.Message}");
                    }

                    var args = reader.ReadCommandLineArguments(compilerCall);
                    var generatedSyntaxTrees = compilationData.GetGeneratedSyntaxTrees();

                    using var analyser = new BinaryLogAnalyser(new LogProgressMonitor(logger), logger, pathTransformer, canonicalPathCache, options.AssemblySensitiveTrap);

                    var exit = Analyse(stopwatch, analyser, options,
                        references => [() => compilation.References.ForEach(r => references.Add(r))],
                        (analyser, syntaxTrees) => [() => syntaxTrees.AddRange(compilation.SyntaxTrees)],
                        (syntaxTrees, references) => compilation,
                        (compilation, options) => analyser.Initialize(
                            compilerCall.ProjectDirectory,
                            compilerArgs?.ToArray() ?? [],
                            TracingAnalyser.GetOutputName(compilation, args),
                            compilation,
                            generatedSyntaxTrees,
                            Path.Combine(compilationIdentifierPath, diagnosticName),
                            options),
                        () => { });

                    switch (exit)
                    {
                        case ExitCode.Ok:
                            allFailed &= false;
                            logger.LogInfo($"  Compilation {diagnosticName} succeeded");
                            break;
                        case ExitCode.Errors:
                            allFailed &= false;
                            logger.LogWarning($"  Compilation {diagnosticName} had errors");
                            break;
                        case ExitCode.Failed:
                            logger.LogWarning($"  Compilation {diagnosticName} failed");
                            break;
                    }
                }
                return allFailed ? ExitCode.Failed : ExitCode.Ok;
            }
            catch (IOException ex)
            {
                logger.LogError($"Failed to open binary log: {ex.Message}");
                return ExitCode.Failed;
            }
        }

        private static ExitCode RunTracingAnalysis(Stopwatch analyzerStopwatch, Options options, ILogger logger, CanonicalPathCache canonicalPathCache, PathTransformer pathTransformer)
        {
            if (options.ProjectsToLoad.Any())
            {
                AddSourceFilesFromProjects(options.ProjectsToLoad, options.CompilerArguments, logger);
            }

            var compilerVersion = new CompilerVersion(options);
            if (compilerVersion.SkipExtraction)
            {
                logger.LogWarning($"  Unrecognized compiler '{compilerVersion.SpecifiedCompiler}' because {compilerVersion.SkipReason}");
                return ExitCode.Ok;
            }

            var workingDirectory = Directory.GetCurrentDirectory();
            var compilerArgs = options.CompilerArguments.ToArray();
            using var analyser = new TracingAnalyser(new LogProgressMonitor(logger), logger, pathTransformer, canonicalPathCache, options.AssemblySensitiveTrap);
            var compilerArguments = CSharpCommandLineParser.Default.Parse(
                compilerVersion.ArgsWithResponse,
                workingDirectory,
                compilerVersion.FrameworkPath,
                compilerVersion.AdditionalReferenceDirectories
                );

            if (compilerArguments is null)
            {
                var sb = new StringBuilder();
                sb.Append("  Failed to parse command line: ").AppendList(" ", compilerArgs);
                logger.LogError(sb.ToString());
                ++analyser.CompilationErrors;
                return ExitCode.Failed;
            }

            if (!analyser.BeginInitialize(compilerVersion.ArgsWithResponse))
            {
                logger.LogInfo("Skipping extraction since files have already been extracted");
                return ExitCode.Ok;
            }

            return AnalyseTracing(workingDirectory, compilerArgs, analyser, compilerArguments, options, analyzerStopwatch);
        }

        private static void AddSourceFilesFromProjects(IEnumerable<string> projectsToLoad, IList<string> compilerArguments, ILogger logger)
        {
            logger.LogInfo("  Loading referenced projects.");
            var projects = new Queue<string>(projectsToLoad);
            var processed = new HashSet<string>();
            while (projects.Count > 0)
            {
                var project = projects.Dequeue();
                var fi = new FileInfo(project);
                if (processed.Contains(fi.FullName))
                {
                    continue;
                }

                processed.Add(fi.FullName);
                logger.LogInfo($"  Processing referenced project: {fi.FullName}");

                var csProj = new CsProjFile(fi);

                foreach (var cs in csProj.Sources)
                {
                    if (cs.Contains("/obj/"))
                    {
                        continue;
                    }
                    compilerArguments.Add(cs);
                }

                foreach (var pr in csProj.ProjectReferences)
                {
                    projects.Enqueue(pr);
                }
            }
        }

        /// <summary>
        /// Gets the complete list of locations to locate references.
        /// </summary>
        /// <param name="args">Command line arguments.</param>
        /// <returns>List of directories.</returns>
        private static IEnumerable<string> FixedReferencePaths(Microsoft.CodeAnalysis.CommandLineArguments args)
        {
            // See https://msdn.microsoft.com/en-us/library/s5bac5fx.aspx
            // on how csc resolves references. Basically,
            // 1) Current working directory. This is the directory from which the compiler is invoked.
            // 2) The common language runtime system directory.
            // 3) Directories specified by / lib.
            // 4) Directories specified by the LIB environment variable.

            if (args.BaseDirectory is not null)
            {
                yield return args.BaseDirectory;
            }

            foreach (var r in args.ReferencePaths)
                yield return r;

            var lib = System.Environment.GetEnvironmentVariable("LIB");
            if (lib is not null)
                yield return lib;
        }

        private static MetadataReference MakeReference(CommandLineReference reference, string path)
        {
            return MetadataReference.CreateFromFile(path).WithProperties(reference.Properties);
        }

        /// <summary>
        /// Construct tasks for resolving references (possibly in parallel).
        ///
        /// The resolved references will be added (thread-safely) to the supplied
        /// list <paramref name="ret"/>.
        /// </summary>
        private static IEnumerable<Action> ResolveReferences(Microsoft.CodeAnalysis.CommandLineArguments args, Analyser analyser, BlockingCollection<MetadataReference> ret)
        {
            var referencePaths = new Lazy<string[]>(() => FixedReferencePaths(args).ToArray());
            return args.MetadataReferences.Select<CommandLineReference, Action>(clref => () =>
            {
                if (Path.IsPathRooted(clref.Reference))
                {
                    if (File.Exists(clref.Reference))
                    {
                        var reference = MakeReference(clref, analyser.PathCache.GetCanonicalPath(clref.Reference));
                        ret.Add(reference);
                    }
                    else
                    {
                        lock (analyser)
                        {
                            analyser.Logger.LogError($"  Reference '{clref.Reference}' does not exist");
                            ++analyser.CompilationErrors;
                        }
                    }
                }
                else
                {
                    var composed = referencePaths.Value
                        .Select(path => Path.Combine(path, clref.Reference))
                        .Where(path => File.Exists(path))
                        .Select(path => analyser.PathCache.GetCanonicalPath(path))
                        .FirstOrDefault();

                    if (composed is not null)
                    {
                        var reference = MakeReference(clref, composed);
                        ret.Add(reference);
                    }
                    else
                    {
                        lock (analyser)
                        {
                            analyser.Logger.LogError($"  Unable to resolve reference '{clref.Reference}'");
                            ++analyser.CompilationErrors;
                        }
                    }
                }
            });
        }

        /// <summary>
        /// Construct tasks for reading source code files (possibly in parallel).
        ///
        /// The constructed syntax trees will be added (thread-safely) to the supplied
        /// list <paramref name="ret"/>.
        /// </summary>
        public static IEnumerable<Action> ReadSyntaxTrees(IEnumerable<string> sources, Analyser analyser, CSharpParseOptions? parseOptions, Encoding? encoding, IList<SyntaxTree> ret)
        {
            return sources.Select<string, Action>(path => () =>
            {
                try
                {
                    using var file = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read);
                    analyser.Logger.LogTrace($"Parsing source file: '{path}'");
                    var tree = CSharpSyntaxTree.ParseText(SourceText.From(file, encoding), parseOptions, path);
                    analyser.Logger.LogTrace($"Source file parsed: '{path}'");

                    lock (ret)
                    {
                        ret.Add(tree);
                    }
                }
                catch (IOException ex)
                {
                    lock (analyser)
                    {
                        analyser.Logger.LogError($"  Unable to open source file {path}: {ex.Message}");
                        ++analyser.CompilationErrors;
                    }
                }
            });
        }

        public static ExitCode Analyse(Stopwatch stopwatch, Analyser analyser, CommonOptions options,
            Func<BlockingCollection<MetadataReference>, IEnumerable<Action>> getResolvedReferenceTasks,
            Func<Analyser, List<SyntaxTree>, IEnumerable<Action>> getSyntaxTreeTasks,
            Func<IEnumerable<SyntaxTree>, IEnumerable<MetadataReference>, CSharpCompilation> getCompilation,
            Action<CSharpCompilation, CommonOptions> initializeAnalyser,
            Action postProcess)
        {
            using var references = new BlockingCollection<MetadataReference>();
            var referenceTasks = getResolvedReferenceTasks(references);

            var syntaxTrees = new List<SyntaxTree>();
            var syntaxTreeTasks = getSyntaxTreeTasks(analyser, syntaxTrees);

            var sw = new Stopwatch();
            sw.Start();

            Parallel.Invoke(
                new ParallelOptions { MaxDegreeOfParallelism = options.Threads },
                referenceTasks.Interleave(syntaxTreeTasks).ToArray());

            if (syntaxTrees.Count == 0)
            {
                analyser.Logger.LogError("  No source files");
                ++analyser.CompilationErrors;
                if (analyser is TracingAnalyser)
                {
                    return ExitCode.Failed;
                }
            }

            var compilation = getCompilation(syntaxTrees, references);

            initializeAnalyser(compilation, options);
            analyser.AnalyseCompilation();
            analyser.AnalyseReferences();

            foreach (var tree in compilation.SyntaxTrees)
            {
                analyser.AnalyseTree(tree);
            }

            sw.Stop();
            analyser.Logger.LogInfo($"  Models constructed in {sw.Elapsed}");
            var elapsed = sw.Elapsed;

            var currentProcess = Process.GetCurrentProcess();
            var cpuTime1 = currentProcess.TotalProcessorTime;
            var userTime1 = currentProcess.UserProcessorTime;

            sw.Restart();
            analyser.PerformExtraction(options.Threads);
            sw.Stop();
            var cpuTime2 = currentProcess.TotalProcessorTime;
            var userTime2 = currentProcess.UserProcessorTime;

            var performance = new Entities.PerformanceMetrics()
            {
                Frontend = new Entities.Timings() { Elapsed = elapsed, Cpu = cpuTime1, User = userTime1 },
                Extractor = new Entities.Timings() { Elapsed = sw.Elapsed, Cpu = cpuTime2 - cpuTime1, User = userTime2 - userTime1 },
                Total = new Entities.Timings() { Elapsed = stopwatch.Elapsed, Cpu = cpuTime2, User = userTime2 },
                PeakWorkingSet = currentProcess.PeakWorkingSet64
            };

            analyser.LogPerformance(performance);
            analyser.Logger.LogInfo($"  Extraction took {sw.Elapsed}");

            postProcess();

            return analyser.TotalErrors == 0 ? ExitCode.Ok : ExitCode.Errors;
        }

        private static ExitCode AnalyseTracing(
            string cwd,
            string[] args,
            TracingAnalyser analyser,
            CSharpCommandLineArguments compilerArguments,
            Options options,
            Stopwatch stopwatch)
        {
            return Analyse(stopwatch, analyser, options,
                references => ResolveReferences(compilerArguments, analyser, references),
                (analyser, syntaxTrees) =>
                {
                    var paths = compilerArguments.SourceFiles
                        .Select(src => src.Path)
                        .ToList();

                    if (compilerArguments.GeneratedFilesOutputDirectory is not null)
                    {
                        paths.AddRange(Directory.GetFiles(compilerArguments.GeneratedFilesOutputDirectory, "*.cs", new EnumerationOptions { RecurseSubdirectories = true, MatchCasing = MatchCasing.CaseInsensitive }));
                    }

                    return ReadSyntaxTrees(
                        paths.Select(analyser.PathCache.GetCanonicalPath).ToHashSet(),
                        analyser,
                        compilerArguments.ParseOptions,
                        compilerArguments.Encoding,
                        syntaxTrees);
                },
                (syntaxTrees, references) =>
                {
                    // csc.exe (CSharpCompiler.cs) also provides CompilationOptions
                    // .WithMetadataReferenceResolver(),
                    // .WithXmlReferenceResolver() and
                    // .WithSourceReferenceResolver().
                    // These would be needed if we hadn't explicitly provided the source/references
                    // already.
                    return CSharpCompilation.Create(
                        compilerArguments.CompilationName,
                        syntaxTrees,
                        references,
                        compilerArguments.CompilationOptions
                            .WithAssemblyIdentityComparer(DesktopAssemblyIdentityComparer.Default)
                            .WithStrongNameProvider(new DesktopStrongNameProvider(compilerArguments.KeyFileSearchPaths))
                            .WithMetadataImportOptions(MetadataImportOptions.All)
                        );
                },
                (compilation, options) => analyser.EndInitialize(compilerArguments, options, compilation, cwd, args),
                () => { });
        }

        /// <summary>
        /// Gets the path to the `csharp.log` file written to by the C# extractor.
        /// </summary>
        public static string GetCSharpLogPath() =>
            Path.Combine(GetCSharpLogDirectory(), "csharp.log");

        /// <summary>
        /// Gets the path to a `csharp.{hash}.txt` file written to by the C# extractor.
        /// </summary>
        public static string GetCSharpArgsLogPath(string hash) =>
            Path.Combine(GetCSharpLogDirectory(), $"csharp.{hash}.txt");

        /// <summary>
        /// Gets a list of all `csharp.{hash}.txt` files currently written to the log directory.
        /// </summary>
        public static IEnumerable<string> GetCSharpArgsLogs()
        {
            try
            {
                return Directory.EnumerateFiles(GetCSharpLogDirectory(), "csharp.*.txt");
            }
            catch (DirectoryNotFoundException)
            {
                // If the directory does not exist, there are no log files
                return Enumerable.Empty<string>();
            }
        }

        private static string GetCSharpLogDirectory()
        {
            var codeQlLogDir = Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_LOG_DIR");
            if (!string.IsNullOrEmpty(codeQlLogDir))
                return codeQlLogDir;

            return Directory.GetCurrentDirectory();
        }
    }
}
