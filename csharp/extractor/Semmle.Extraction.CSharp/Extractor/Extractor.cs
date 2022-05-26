using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.Text;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Util;
using System.Text;
using System.Diagnostics;
using System.Threading.Tasks;
using Semmle.Util.Logging;
using System.Collections.Concurrent;
using System.Globalization;
using System.Threading;

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
                    logger.Log(Severity.Info, "  {0} ({1})", source,
                        action == AnalysisAction.Extracted
                            ? time.ToString()
                            : action == AnalysisAction.Excluded
                                ? "excluded"
                                : "up to date");
                }
            }

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
            var fileLogger = new FileLogger(verbosity, GetCSharpLogPath());
            return includeConsole
                ? new CombinedLogger(new ConsoleLogger(verbosity), fileLogger)
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
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            var options = Options.CreateWithEnvironment(args);
            Entities.Compilation.Settings = (Directory.GetCurrentDirectory(), options.CompilerArguments.ToArray());

            using var logger = MakeLogger(options.Verbosity, options.Console);

            if (Environment.GetEnvironmentVariable("SEMMLE_CLRTRACER") == "1" && !options.ClrTracer)
            {
                logger.Log(Severity.Info, "Skipping extraction since already extracted from the CLR tracer");
                return ExitCode.Ok;
            }

            var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
            var pathTransformer = new PathTransformer(canonicalPathCache);

            using var analyser = new TracingAnalyser(new LogProgressMonitor(logger), logger, options.AssemblySensitiveTrap, pathTransformer);

            try
            {
                if (options.ProjectsToLoad.Any())
                {
                    AddSourceFilesFromProjects(options.ProjectsToLoad, options.CompilerArguments, logger);
                }

                var compilerVersion = new CompilerVersion(options);

                if (compilerVersion.SkipExtraction)
                {
                    logger.Log(Severity.Warning, "  Unrecognized compiler '{0}' because {1}", compilerVersion.SpecifiedCompiler, compilerVersion.SkipReason);
                    return ExitCode.Ok;
                }

                var compilerArguments = CSharpCommandLineParser.Default.Parse(
                    compilerVersion.ArgsWithResponse,
                    Entities.Compilation.Settings.Cwd,
                    compilerVersion.FrameworkPath,
                    compilerVersion.AdditionalReferenceDirectories
                    );

                if (compilerArguments is null)
                {
                    var sb = new StringBuilder();
                    sb.Append("  Failed to parse command line: ").AppendList(" ", Entities.Compilation.Settings.Args);
                    logger.Log(Severity.Error, sb.ToString());
                    ++analyser.CompilationErrors;
                    return ExitCode.Failed;
                }

                if (!analyser.BeginInitialize(compilerVersion.ArgsWithResponse))
                {
                    logger.Log(Severity.Info, "Skipping extraction since files have already been extracted");
                    return ExitCode.Ok;
                }

                return AnalyseTracing(analyser, compilerArguments, options, canonicalPathCache, stopwatch);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                logger.Log(Severity.Error, "  Unhandled exception: {0}", ex);
                return ExitCode.Errors;
            }
        }

        private static void AddSourceFilesFromProjects(IEnumerable<string> projectsToLoad, IList<string> compilerArguments, ILogger logger)
        {
            logger.Log(Severity.Info, "  Loading referenced projects.");
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
                logger.Log(Severity.Info, "  Processing referenced project: " + fi.FullName);

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
        private static IEnumerable<Action> ResolveReferences(Microsoft.CodeAnalysis.CommandLineArguments args, Analyser analyser, CanonicalPathCache canonicalPathCache, BlockingCollection<MetadataReference> ret)
        {
            var referencePaths = new Lazy<string[]>(() => FixedReferencePaths(args).ToArray());
            return args.MetadataReferences.Select<CommandLineReference, Action>(clref => () =>
            {
                if (Path.IsPathRooted(clref.Reference))
                {
                    if (File.Exists(clref.Reference))
                    {
                        var reference = MakeReference(clref, canonicalPathCache.GetCanonicalPath(clref.Reference));
                        ret.Add(reference);
                    }
                    else
                    {
                        lock (analyser)
                        {
                            analyser.Logger.Log(Severity.Error, "  Reference '{0}' does not exist", clref.Reference);
                            ++analyser.CompilationErrors;
                        }
                    }
                }
                else
                {
                    var composed = referencePaths.Value
                        .Select(path => Path.Combine(path, clref.Reference))
                        .Where(path => File.Exists(path))
                        .Select(path => canonicalPathCache.GetCanonicalPath(path))
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
                            analyser.Logger.Log(Severity.Error, "  Unable to resolve reference '{0}'", clref.Reference);
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
                    var st = CSharpSyntaxTree.ParseText(SourceText.From(file, encoding), parseOptions, path);
                    lock (ret)
                        ret.Add(st);
                }
                catch (IOException ex)
                {
                    lock (analyser)
                    {
                        analyser.Logger.Log(Severity.Error, "  Unable to open source file {0}: {1}", path, ex.Message);
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
            Action analyseCompilation,
            Action<Entities.PerformanceMetrics> logPerformance,
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
                analyser.Logger.Log(Severity.Error, "  No source files");
                ++analyser.CompilationErrors;
                if (analyser is TracingAnalyser)
                {
                    return ExitCode.Failed;
                }
            }

            var compilation = getCompilation(syntaxTrees, references);

            initializeAnalyser(compilation, options);
            analyseCompilation();
            analyser.AnalyseReferences();

            foreach (var tree in compilation.SyntaxTrees)
            {
                analyser.AnalyseTree(tree);
            }

            sw.Stop();
            analyser.Logger.Log(Severity.Info, "  Models constructed in {0}", sw.Elapsed);
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

            logPerformance(performance);
            analyser.Logger.Log(Severity.Info, "  Extraction took {0}", sw.Elapsed);

            postProcess();

            return analyser.TotalErrors == 0 ? ExitCode.Ok : ExitCode.Errors;
        }

        private static ExitCode AnalyseTracing(
            TracingAnalyser analyser,
            CSharpCommandLineArguments compilerArguments,
            Options options,
            CanonicalPathCache canonicalPathCache,
            Stopwatch stopwatch)
        {
            return Analyse(stopwatch, analyser, options,
                references => ResolveReferences(compilerArguments, analyser, canonicalPathCache, references),
                (analyser, syntaxTrees) =>
                {
                    return ReadSyntaxTrees(
                        compilerArguments.SourceFiles.Select(src => canonicalPathCache.GetCanonicalPath(src.Path)),
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
                (compilation, options) => analyser.EndInitialize(compilerArguments, options, compilation),
                () => analyser.AnalyseCompilation(),
                performance => analyser.LogPerformance(performance),
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
