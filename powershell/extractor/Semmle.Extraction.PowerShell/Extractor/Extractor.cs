using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Semmle.Util;
using Semmle.Util.Logging;
using System.Management.Automation;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Extractor
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
            var fileLogger = new FileLogger(options.Verbosity, GetPowerShellLogPath());
            using var logger = options.Console
                ? new CombinedLogger(new ConsoleLogger(options.Verbosity), fileLogger)
                : (ILogger)fileLogger;

            var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
            var pathTransformer = new PathTransformer(canonicalPathCache);

            using var analyser = new Analyser(new LogProgressMonitor(logger), logger, options.AssemblySensitiveTrap, pathTransformer, options);

            try
            {
                var filesToParse = EnumerateSourceFiles(options.ProjectsToLoad, options.CompilerArguments, logger);
                var sw = new Stopwatch();
                var progressMon = new LogProgressMonitor(logger);
                return Analyse(sw, analyser, options, filesToParse, progressMon, (_) => { });
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                logger.Log(Severity.Error, "  Unhandled exception: {0}", ex);
                return ExitCode.Errors;
            }
        }

        private static IEnumerable<string> EnumerateSourceFiles(IEnumerable<string> scriptsToLoad, IList<string> compilerArguments, ILogger logger)
        {
            logger.Log(Severity.Info, "  Loading referenced scripts.");
            var scripts = new Queue<string>(scriptsToLoad);
            var processed = new HashSet<string>();
            while (scripts.Count > 0)
            {
                var script = scripts.Dequeue();
                var fi = new FileInfo(script);
                if (processed.Contains(fi.FullName))
                {
                    continue;
                }

                processed.Add(fi.FullName);
                logger.Log(Severity.Info, "  Processing referenced project: " + fi.FullName);
            }
            return processed;
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

        /// <summary>
        /// Construct tasks for reading source code files (possibly in parallel).
        ///
        /// The constructed CompiledScripts trees will be added (thread-safely) to the supplied
        /// list <paramref name="ret"/>.
        /// </summary>
        private static IEnumerable<Action> CompileScripts(IEnumerable<string> sources, Analyser analyser, IList<CompiledScript> ret)
        {
            return sources.Select<string, Action>(path =>
            {
                Action action = () =>
                {
                    try
                    {
                        ScriptBlockAst ast = Parser.ParseFile(path, out Token[] tokens, out ParseError[] errors);

                        lock (ret)
                            ret.Add(new CompiledScript(path, ast, tokens, errors));
                    }
                    catch (IOException ex)
                    {
                        lock (analyser)
                        {
                            analyser.Logger.Log(Severity.Error, "  Unable to open source file {0}: {1}", path, ex.Message);
                            ++analyser.CompilationErrors;
                        }
                    }
                    catch (Exception e)
                    {
                        lock (analyser)
                        {
                            analyser.Logger.Log(Severity.Error, "  Unable to open source file {0}: {1} ({2})", path, e.Message);
                            ++analyser.CompilationErrors;
                        }
                    }
                };
                return action;
            });
        }

        public static void ExtractStandalone(
            IEnumerable<string> sources,
            IProgressMonitor pm,
            ILogger logger,
            CommonOptions options)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
            var pathTransformer = new PathTransformer(canonicalPathCache);

            using var analyser = new Analyser(pm, logger, false, pathTransformer, options);
            try
            {
                AnalyseStandalone(analyser, sources, options, pm, stopwatch);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                analyser.Logger.Log(Severity.Error, "  Unhandled exception: {0}", ex);
            }
        }

        private static ExitCode Analyse(Stopwatch stopwatch, 
            Analyser analyser, 
            CommonOptions options, 
            IEnumerable<string> sources,
            IProgressMonitor progressMonitor,
            Action<Entities.PerformanceMetrics> logPerformance)
        {
            var sw = new Stopwatch();
            sw.Start();

            var compiledScripts = new List<CompiledScript>();
            var csActions = CompileScripts(sources, analyser, compiledScripts);

            Parallel.Invoke(
                new ParallelOptions { MaxDegreeOfParallelism = options.Threads },
                csActions.ToArray());

            if (compiledScripts.Count == 0)
            {
                analyser.Logger.Log(Severity.Error, "  No source files");
                ++analyser.CompilationErrors;
            }

            foreach (var script in compiledScripts)
            {
                analyser.QueueAnalyzeScriptTask(script);
            }

            sw.Stop();
            analyser.Logger.Log(Severity.Info, "  Models constructed in {0}", sw.Elapsed);
            var elapsed = sw.Elapsed;

            var currentProcess = Process.GetCurrentProcess();
            var cpuTime1 = currentProcess.TotalProcessorTime;
            var userTime1 = currentProcess.UserProcessorTime;

            sw.Restart();
            analyser.PerformExtractionTasks(options.Threads);
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

            return analyser.TotalErrors == 0 ? ExitCode.Ok : ExitCode.Errors;
        }

        private static void AnalyseStandalone(
            Analyser analyser,
            IEnumerable<string> sources,
            CommonOptions options,
            IProgressMonitor progressMonitor,
            Stopwatch stopwatch)
        {
            Analyse(stopwatch, analyser, options, sources, progressMonitor, (_) => { });
        }

        /// <summary>
        /// Gets the path to the `powershell.log` file written to by the PowerShell extractor.
        /// </summary>
        public static string GetPowerShellLogPath() =>
            Path.Combine(GetPowerShellLogDirectory(), "powershell.log");

        /// <summary>
        /// Gets the path to the `powershell.log` file written to by the PowerShell extractor.
        /// </summary>
        public static string GetPowerShellArgsLogsPath(string hash) =>
            Path.Combine(GetPowerShellLogDirectory(), $"powershell.{hash}.txt");

        /// <summary>
        /// Gets a list of all `powershell.{hash}.txt` files currently written to the log directory.
        /// </summary>
        public static IEnumerable<string> GetPowerShellArgsLogs() =>
            Directory.EnumerateFiles(GetPowerShellLogDirectory(), "powershell.*.txt");

        private static string GetPowerShellLogDirectory()
        {
            var codeQlLogDir = Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_POWERSHELL_LOG_DIR");
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
