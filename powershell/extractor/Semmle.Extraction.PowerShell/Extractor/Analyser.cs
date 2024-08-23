using Microsoft.CodeAnalysis.Text;
using Semmle.Util.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Management.Automation.Language;
using System.Net.Http;
using System.Threading.Tasks;
using Semmle.Extraction.PowerShell.Entities;
using File = System.IO.File;

/*
 * Test
 */
namespace Semmle.Extraction.PowerShell
{
    /// <summary>
    /// Encapsulates a PowerShell analysis task.
    /// </summary>
    public class Analyser : IDisposable
    {
        protected Extraction.Extractor? extractor;
        protected Layout? layout;
        protected CommonOptions? options;

        private readonly object progressMutex = new object();

        // The bulk of the extraction work, potentially executed in parallel.
        protected readonly List<Action> extractionTasks = new List<Action>();
        private int taskCount = 0;

        private readonly Stopwatch stopWatch = new Stopwatch();

        private readonly IProgressMonitor progressMonitor;

        public ILogger Logger { get; }

        protected readonly bool addAssemblyTrapPrefix;

        public PathTransformer PathTransformer { get; }

        public Analyser(IProgressMonitor pm, ILogger logger, bool addAssemblyTrapPrefix, PathTransformer pathTransformer, CommonOptions options)
        {
            Logger = logger;
            this.addAssemblyTrapPrefix = addAssemblyTrapPrefix;
            Logger.Log(Severity.Info, "EXTRACTION STARTING at {0}", DateTime.Now);
            stopWatch.Start();
            progressMonitor = pm;
            PathTransformer = pathTransformer;
            extractor = new StandaloneExtractor(Logger, PathTransformer);
            this.options = options;
            layout = new Layout();
            LogExtractorInfo(Extraction.Extractor.Version);
        }

        /// <summary>
        /// Perform an analysis on a source file/syntax tree.
        /// </summary>
        /// <param name="script">Syntax tree to analyse.</param>
        public void QueueAnalyzeScriptTask(CompiledScript script)
        {
            extractionTasks.Add(() => DoExtractScript(script));
        }

#nullable disable warnings

        private Microsoft.CodeAnalysis.Location GetCodeAnalysisLocationForToken(string path, Token token)
        {
            return Microsoft.CodeAnalysis.Location.Create(path,
                new TextSpan(token.Extent.StartOffset, token.Extent.EndOffset - token.Extent.StartOffset),
                new LinePositionSpan(new LinePosition(token.Extent.StartLineNumber, token.Extent.StartColumnNumber), 
                    new LinePosition(token.Extent.EndLineNumber, token.Extent.EndColumnNumber)));
        }

        private void DoExtractScript(CompiledScript script)
        {
            try
            {
                Stopwatch stopwatch = new Stopwatch();
                stopwatch.Start();
                string sourcePath = script.Location;
                PathTransformer.ITransformedPath transformedSourcePath = PathTransformer.Transform(sourcePath);

                Layout.SubProject projectLayout = layout.LookupProjectOrNull(transformedSourcePath);
                bool excluded = projectLayout is null;
                string trapPath = excluded ? "" : projectLayout!.GetTrapPath(Logger, transformedSourcePath, options.TrapCompression);
                bool upToDate = false;

                if (!excluded)
                {
                    using TrapWriter trapWriter = projectLayout!.CreateTrapWriter(Logger, transformedSourcePath, options.TrapCompression, discardDuplicates: false);

                    upToDate = options.Fast && FileIsUpToDate(sourcePath, trapWriter.TrapFile);

                    if (!upToDate)
                    {
                        PowerShellContext cx = new PowerShellContext(extractor, script, trapWriter, addAssemblyTrapPrefix);
                        // Ensure that the file itself is populated in case the source file is totally empty
                        Entities.File.Create(cx, sourcePath);
                        // Parse any comments
                        foreach (var token in script.Tokens.Where(x => x.Kind == TokenKind.Comment))
                        {
                            CommentEntity.Create(cx, token);
                        }
                        // Parse the AST contained in script.ParseResult
                        script.ParseResult.Visit(new PowerShellVisitor2(cx));
                        cx.PopulateAll();
                    }
                }

                ReportProgress(sourcePath, trapPath, stopwatch.Elapsed, excluded
                    ? AnalysisAction.Excluded
                    : upToDate
                        ? AnalysisAction.UpToDate
                        : AnalysisAction.Extracted);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                extractor.Message(new Message($"Unhandled exception processing syntax tree. {ex.Message}", script.Location, null, ex.StackTrace));
            }
        }

#nullable restore warnings

        private static bool FileIsUpToDate(string src, string dest)
        {
            return File.Exists(dest) &&
                File.GetLastWriteTime(dest) >= File.GetLastWriteTime(src);
        }

        private void ReportProgress(string src, string output, TimeSpan time, AnalysisAction action)
        {
            lock (progressMutex)
                progressMonitor.Analysed(++taskCount, extractionTasks.Count, src, output, time, action);
        }

        /// <summary>
        /// Run all extraction tasks.
        /// </summary>
        /// <param name="numberOfThreads">The number of threads to use.</param>
        public void PerformExtractionTasks(int numberOfThreads)
        {
            Parallel.Invoke(
                new ParallelOptions { MaxDegreeOfParallelism = numberOfThreads },
                extractionTasks.ToArray());
        }

        public virtual void Dispose()
        {
            stopWatch.Stop();
            Logger.Log(Severity.Info, "  Peak working set = {0} MB", Process.GetCurrentProcess().PeakWorkingSet64 / (1024 * 1024));

            if (TotalErrors > 0)
                Logger.Log(Severity.Info, "EXTRACTION FAILED with {0} error{1} in {2}", TotalErrors, TotalErrors == 1 ? "" : "s", stopWatch.Elapsed);
            else
                Logger.Log(Severity.Info, "EXTRACTION SUCCEEDED in {0}", stopWatch.Elapsed);

            Logger.Dispose();
        }

        /// <summary>
        /// Number of errors encountered during extraction.
        /// </summary>
        private int ExtractorErrors => extractor?.Errors ?? 0;

        /// <summary>
        /// Number of errors encountered by the compiler.
        /// </summary>
        public int CompilationErrors { get; set; }

        /// <summary>
        /// Total number of errors reported.
        /// </summary>
        public int TotalErrors => CompilationErrors + ExtractorErrors;

        /// <summary>
        /// Logs information about the extractor.
        /// </summary>
        public void LogExtractorInfo(string extractorVersion)
        {
            Logger.Log(Severity.Info, "  Extractor: {0}", Environment.GetCommandLineArgs().First());
            Logger.Log(Severity.Info, "  Extractor version: {0}", extractorVersion);
            Logger.Log(Severity.Info, "  Current working directory: {0}", Directory.GetCurrentDirectory());
        }
    }
}
