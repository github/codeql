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

namespace Semmle.Extraction.CSharp
{
    public static class Extractor
    {
        public enum ExitCode
        {
            Ok,         // Everything worked perfectly
            Errors,     // Trap was generated but there were processing errors
            Failed      // Trap could not be generated
        }

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
            var commandLineArguments = Options.CreateWithEnvironment(args);
            var fileLogger = new FileLogger(commandLineArguments.Verbosity, GetCSharpLogPath());
            using var logger = commandLineArguments.Console
                ? new CombinedLogger(new ConsoleLogger(commandLineArguments.Verbosity), fileLogger)
                : (ILogger)fileLogger;

            if (Environment.GetEnvironmentVariable("SEMMLE_CLRTRACER") == "1" && !commandLineArguments.ClrTracer)
            {
                logger.Log(Severity.Info, "Skipping extraction since already extracted from the CLR tracer");
                return ExitCode.Ok;
            }

            var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
            var pathTransformer = new PathTransformer(canonicalPathCache);

            using var analyser = new Analyser(new LogProgressMonitor(logger), logger, commandLineArguments.AssemblySensitiveTrap, pathTransformer);
            using var references = new BlockingCollection<MetadataReference>();
            try
            {
                var compilerVersion = new CompilerVersion(commandLineArguments);

                if (compilerVersion.SkipExtraction)
                {
                    logger.Log(Severity.Warning, "  Unrecognized compiler '{0}' because {1}", compilerVersion.SpecifiedCompiler, compilerVersion.SkipReason);
                    return ExitCode.Ok;
                }

                var cwd = Directory.GetCurrentDirectory();
                var compilerArguments = CSharpCommandLineParser.Default.Parse(
                    compilerVersion.ArgsWithResponse,
                    cwd,
                    compilerVersion.FrameworkPath,
                    compilerVersion.AdditionalReferenceDirectories
                    );

                if (compilerArguments == null)
                {
                    var sb = new StringBuilder();
                    sb.Append("  Failed to parse command line: ").AppendList(" ", args);
                    logger.Log(Severity.Error, sb.ToString());
                    ++analyser.CompilationErrors;
                    return ExitCode.Failed;
                }

                if (!analyser.BeginInitialize(compilerVersion.ArgsWithResponse))
                {
                    logger.Log(Severity.Info, "Skipping extraction since files have already been extracted");
                    return ExitCode.Ok;
                }

                var referenceTasks = ResolveReferences(compilerArguments, analyser, canonicalPathCache, references);

                var syntaxTrees = new List<SyntaxTree>();
                var syntaxTreeTasks = ReadSyntaxTrees(
                    compilerArguments.SourceFiles.
                    Select(src => canonicalPathCache.GetCanonicalPath(src.Path)),
                    analyser,
                    compilerArguments.ParseOptions,
                    compilerArguments.Encoding,
                    syntaxTrees);

                var sw1 = new Stopwatch();
                sw1.Start();

                Parallel.Invoke(
                    new ParallelOptions { MaxDegreeOfParallelism = commandLineArguments.Threads },
                    referenceTasks.Interleave(syntaxTreeTasks).ToArray());

                if (syntaxTrees.Count == 0)
                {
                    logger.Log(Severity.Error, "  No source files");
                    ++analyser.CompilationErrors;
                    return ExitCode.Failed;
                }

                // csc.exe (CSharpCompiler.cs) also provides CompilationOptions
                // .WithMetadataReferenceResolver(),
                // .WithXmlReferenceResolver() and
                // .WithSourceReferenceResolver().
                // These would be needed if we hadn't explicitly provided the source/references
                // already.
                var compilation = CSharpCompilation.Create(
                    compilerArguments.CompilationName,
                    syntaxTrees,
                    references,
                    compilerArguments.CompilationOptions.
                        WithAssemblyIdentityComparer(DesktopAssemblyIdentityComparer.Default).
                        WithStrongNameProvider(new DesktopStrongNameProvider(compilerArguments.KeyFileSearchPaths))
                    );

                analyser.EndInitialize(compilerArguments, commandLineArguments, compilation);
                analyser.AnalyseCompilation(cwd, args);
                analyser.AnalyseReferences();

                foreach (var tree in compilation.SyntaxTrees)
                {
                    analyser.AnalyseTree(tree);
                }

                var currentProcess = Process.GetCurrentProcess();
                var cpuTime1 = currentProcess.TotalProcessorTime;
                var userTime1 = currentProcess.UserProcessorTime;
                sw1.Stop();
                logger.Log(Severity.Info, "  Models constructed in {0}", sw1.Elapsed);

                var sw2 = new Stopwatch();
                sw2.Start();
                analyser.PerformExtraction(commandLineArguments.Threads);
                sw2.Stop();
                var cpuTime2 = currentProcess.TotalProcessorTime;
                var userTime2 = currentProcess.UserProcessorTime;

                var performance = new Entities.PerformanceMetrics()
                {
                    Frontend = new Entities.Timings() { Elapsed = sw1.Elapsed, Cpu = cpuTime1, User = userTime1 },
                    Extractor = new Entities.Timings() { Elapsed = sw2.Elapsed, Cpu = cpuTime2 - cpuTime1, User = userTime2 - userTime1 },
                    Total = new Entities.Timings() { Elapsed = stopwatch.Elapsed, Cpu = cpuTime2, User = userTime2 },
                    PeakWorkingSet = currentProcess.PeakWorkingSet64
                };

                analyser.LogPerformance(performance);
                logger.Log(Severity.Info, "  Extraction took {0}", sw2.Elapsed);

                return analyser.TotalErrors == 0 ? ExitCode.Ok : ExitCode.Errors;
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                logger.Log(Severity.Error, "  Unhandled exception: {0}", ex);
                return ExitCode.Errors;
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

            yield return args.BaseDirectory;

            foreach (var r in args.ReferencePaths)
                yield return r;

            var lib = System.Environment.GetEnvironmentVariable("LIB");
            if (lib != null)
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

                    if (composed is object)
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
        private static IEnumerable<Action> ReadSyntaxTrees(IEnumerable<string> sources, Analyser analyser, CSharpParseOptions parseOptions, Encoding encoding, IList<SyntaxTree> ret)
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

        public static void ExtractStandalone(
            IEnumerable<string> sources,
            IEnumerable<string> referencePaths,
            IProgressMonitor pm,
            ILogger logger,
            CommonOptions options)
        {
            var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
            var pathTransformer = new PathTransformer(canonicalPathCache);

            using var analyser = new Analyser(pm, logger, false, pathTransformer);
            using var references = new BlockingCollection<MetadataReference>();
            try
            {
                var referenceTasks = referencePaths.Select<string, Action>(path => () =>
                {
                    var reference = MetadataReference.CreateFromFile(path);
                    references.Add(reference);
                });

                var syntaxTrees = new List<SyntaxTree>();
                var syntaxTreeTasks = ReadSyntaxTrees(sources, analyser, null, null, syntaxTrees);

                var sw = new Stopwatch();
                sw.Start();

                Parallel.Invoke(
                    new ParallelOptions { MaxDegreeOfParallelism = options.Threads },
                    referenceTasks.Interleave(syntaxTreeTasks).ToArray());

                if (syntaxTrees.Count == 0)
                {
                    analyser.Logger.Log(Severity.Error, "  No source files");
                    ++analyser.CompilationErrors;
                }

                var compilation = CSharpCompilation.Create(
                    "csharp.dll",
                    syntaxTrees,
                    references
                    );

                analyser.InitializeStandalone(compilation, options);
                analyser.AnalyseReferences();

                foreach (var tree in compilation.SyntaxTrees)
                {
                    analyser.AnalyseTree(tree);
                }

                sw.Stop();
                analyser.Logger.Log(Severity.Info, "  Models constructed in {0}", sw.Elapsed);

                sw.Restart();
                analyser.PerformExtraction(options.Threads);
                sw.Stop();
                analyser.Logger.Log(Severity.Info, "  Extraction took {0}", sw.Elapsed);

                foreach (var type in analyser.MissingNamespaces)
                {
                    pm.MissingNamespace(type);
                }

                foreach (var type in analyser.MissingTypes)
                {
                    pm.MissingType(type);
                }

                pm.MissingSummary(analyser.MissingTypes.Count(), analyser.MissingNamespaces.Count());
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                analyser.Logger.Log(Severity.Error, "  Unhandled exception: {0}", ex);
            }
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
        public static IEnumerable<string> GetCSharpArgsLogs() =>
            Directory.EnumerateFiles(GetCSharpLogDirectory(), "csharp.*.txt");

        private static string GetCSharpLogDirectory()
        {
            var codeQlLogDir = Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_LOG_DIR");
            if (!string.IsNullOrEmpty(codeQlLogDir))
                return codeQlLogDir;

            var snapshot = Environment.GetEnvironmentVariable("ODASA_SNAPSHOT");
            if (!string.IsNullOrEmpty(snapshot))
                return Path.Combine(snapshot, "log");

            var buildErrorDir = Environment.GetEnvironmentVariable("ODASA_BUILD_ERROR_DIR");
            if (!string.IsNullOrEmpty(buildErrorDir))
                // Used by `qltest`
                return buildErrorDir;

            var traps = Environment.GetEnvironmentVariable("TRAP_FOLDER");
            if (!string.IsNullOrEmpty(traps))
                return traps;

            return Directory.GetCurrentDirectory();
        }
    }
}
