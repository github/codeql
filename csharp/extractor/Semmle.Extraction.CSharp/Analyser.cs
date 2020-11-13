using System;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using System.IO;
using System.Linq;
using Semmle.Extraction.CSharp.Populators;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Diagnostics;
using Semmle.Util.Logging;
using Semmle.Util;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Encapsulates a C# analysis task.
    /// </summary>
    public sealed class Analyser : IDisposable
    {
        private IExtractor extractor;
        private CSharpCompilation compilation;
        private Layout layout;
        private bool init;
        private readonly object progressMutex = new object();
        private int taskCount = 0;
        private CommonOptions options;
        private Entities.Compilation compilationEntity;
        private IDisposable compilationTrapFile;

        private readonly Stopwatch stopWatch = new Stopwatch();

        private readonly IProgressMonitor progressMonitor;

        public ILogger Logger { get; }

        public bool AddAssemblyTrapPrefix { get; }

        public PathTransformer PathTransformer { get; }

        public Analyser(IProgressMonitor pm, ILogger logger, bool addAssemblyTrapPrefix, PathTransformer pathTransformer)
        {
            Logger = logger;
            AddAssemblyTrapPrefix = addAssemblyTrapPrefix;
            Logger.Log(Severity.Info, "EXTRACTION STARTING at {0}", DateTime.Now);
            stopWatch.Start();
            progressMonitor = pm;
            PathTransformer = pathTransformer;
        }

        /// <summary>
        /// Start initialization of the analyser.
        /// </summary>
        /// <param name="roslynArgs">The arguments passed to Roslyn.</param>
        /// <returns>A Boolean indicating whether to proceed with extraction.</returns>
        public bool BeginInitialize(IEnumerable<string> roslynArgs)
        {
            return init = LogRoslynArgs(roslynArgs, Extraction.Extractor.Version);
        }

        /// <summary>
        /// End initialization of the analyser.
        /// </summary>
        /// <param name="commandLineArguments">Arguments passed to csc.</param>
        /// <param name="options">Extractor options.</param>
        /// <param name="compilation">The Roslyn compilation.</param>
        /// <returns>A Boolean indicating whether to proceed with extraction.</returns>
        public void EndInitialize(
           CSharpCommandLineArguments commandLineArguments,
           Options options,
           CSharpCompilation compilation)
        {
            if (!init)
                throw new InternalError("EndInitialize called without BeginInitialize returning true");
            layout = new Layout();
            this.options = options;
            this.compilation = compilation;
            extractor = new Extraction.Extractor(false, GetOutputName(compilation, commandLineArguments), Logger, PathTransformer);
            LogDiagnostics();

            SetReferencePaths();

            CompilationErrors += FilteredDiagnostics.Count();
        }

        /// <summary>
        ///     Constructs the map from assembly string to its filename.
        ///
        ///     Roslyn doesn't record the relationship between a filename and its assembly
        ///     information, so we need to retrieve this information manually.
        /// </summary>
        private void SetReferencePaths()
        {
            foreach (var reference in compilation.References.OfType<PortableExecutableReference>())
            {
                try
                {
                    var refPath = reference.FilePath;

                    /*  This method is significantly faster and more lightweight than using
                     *  System.Reflection.Assembly.ReflectionOnlyLoadFrom. It is also allows
                     *  loading the same assembly from different locations.
                     */
                    using var pereader = new System.Reflection.PortableExecutable.PEReader(new FileStream(refPath, FileMode.Open, FileAccess.Read, FileShare.Read));

                    var metadata = pereader.GetMetadata();
                    string assemblyIdentity;
                    unsafe
                    {
                        var reader = new System.Reflection.Metadata.MetadataReader(metadata.Pointer, metadata.Length);
                        var def = reader.GetAssemblyDefinition();
                        assemblyIdentity = reader.GetString(def.Name) + " " + def.Version;
                    }
                    extractor.SetAssemblyFile(assemblyIdentity, refPath);

                }
                catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
                {
                    extractor.Message(new Message("Exception reading reference file", reference.FilePath, null, ex.StackTrace));
                }
            }
        }

        public void InitializeStandalone(CSharpCompilation compilationIn, CommonOptions options)
        {
            compilation = compilationIn;
            layout = new Layout();
            extractor = new Extraction.Extractor(true, null, Logger, PathTransformer);
            this.options = options;
            LogExtractorInfo(Extraction.Extractor.Version);
            SetReferencePaths();
        }

        private readonly HashSet<string> errorsToIgnore = new HashSet<string>
        {
            "CS7027",   // Code signing failure
            "CS1589",   // XML referencing not supported
            "CS1569"    // Error writing XML documentation
        };

        private IEnumerable<Diagnostic> FilteredDiagnostics
        {
            get
            {
                return extractor == null || extractor.Standalone || compilation == null ? Enumerable.Empty<Diagnostic>() :
                    compilation.
                    GetDiagnostics().
                    Where(e => e.Severity >= DiagnosticSeverity.Error && !errorsToIgnore.Contains(e.Id));
            }
        }

        public IEnumerable<string> MissingTypes => extractor.MissingTypes;

        public IEnumerable<string> MissingNamespaces => extractor.MissingNamespaces;

        /// <summary>
        /// Determine the path of the output dll/exe.
        /// </summary>
        /// <param name="compilation">Information about the compilation.</param>
        /// <param name="cancel">Cancellation token required.</param>
        /// <returns>The filename.</returns>
        private static string GetOutputName(CSharpCompilation compilation,
            CSharpCommandLineArguments commandLineArguments)
        {
            // There's no apparent way to access the output filename from the compilation,
            // so we need to re-parse the command line arguments.

            if (commandLineArguments.OutputFileName == null)
            {
                // No output specified: Use name based on first filename
                var entry = compilation.GetEntryPoint(System.Threading.CancellationToken.None);
                if (entry == null)
                {
                    if (compilation.SyntaxTrees.Length == 0)
                        throw new InvalidOperationException("No source files seen");

                    // Probably invalid, but have a go anyway.
                    var entryPointFile = compilation.SyntaxTrees.First().FilePath;
                    return Path.ChangeExtension(entryPointFile, ".exe");
                }

                var entryPointFilename = entry.Locations.First().SourceTree.FilePath;
                return Path.ChangeExtension(entryPointFilename, ".exe");
            }

            return Path.Combine(commandLineArguments.OutputDirectory, commandLineArguments.OutputFileName);
        }

        /// <summary>
        /// Perform an analysis on a source file/syntax tree.
        /// </summary>
        /// <param name="tree">Syntax tree to analyse.</param>
        public void AnalyseTree(SyntaxTree tree)
        {
            extractionTasks.Add(() => DoExtractTree(tree));
        }

        /// <summary>
        /// Perform an analysis on an assembly.
        /// </summary>
        /// <param name="assembly">Assembly to analyse.</param>
        private void AnalyseReferenceAssembly(PortableExecutableReference assembly)
        {
            // CIL first - it takes longer.
            if (options.CIL)
                extractionTasks.Add(() => DoExtractCIL(assembly));
            extractionTasks.Add(() => DoAnalyseReferenceAssembly(assembly));
        }

        private static bool FileIsUpToDate(string src, string dest)
        {
            return File.Exists(dest) &&
                File.GetLastWriteTime(dest) >= File.GetLastWriteTime(src);
        }

        /// <summary>
        /// Extracts compilation-wide entities, such as compilations and compiler diagnostics.
        /// </summary>
        public void AnalyseCompilation(string cwd, string[] args)
        {
            extractionTasks.Add(() => DoAnalyseCompilation(cwd, args));
        }



        private void DoAnalyseCompilation(string cwd, string[] args)
        {
            try
            {
                var assemblyPath = extractor.OutputPath;
                var transformedAssemblyPath = PathTransformer.Transform(assemblyPath);
                var assembly = compilation.Assembly;
                var projectLayout = layout.LookupProjectOrDefault(transformedAssemblyPath);
                var trapWriter = projectLayout.CreateTrapWriter(Logger, transformedAssemblyPath, options.TrapCompression, discardDuplicates: false);
                compilationTrapFile = trapWriter;  // Dispose later
                var cx = extractor.CreateContext(compilation.Clone(), trapWriter, new AssemblyScope(assembly, assemblyPath, true), AddAssemblyTrapPrefix);

                compilationEntity = new Entities.Compilation(cx, cwd, args);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Logger.Log(Severity.Error, "  Unhandled exception analyzing {0}: {1}", "compilation", ex);
            }
        }

        public void LogPerformance(Entities.PerformanceMetrics p) => compilationEntity.PopulatePerformance(p);

        /// <summary>
        ///     Extract an assembly to a new trap file.
        ///     If the trap file exists, skip extraction to avoid duplicating
        ///     extraction within the snapshot.
        /// </summary>
        /// <param name="r">The assembly to extract.</param>
        private void DoAnalyseReferenceAssembly(PortableExecutableReference r)
        {
            try
            {
                var stopwatch = new Stopwatch();
                stopwatch.Start();

                var assemblyPath = r.FilePath;
                var transformedAssemblyPath = PathTransformer.Transform(assemblyPath);
                var projectLayout = layout.LookupProjectOrDefault(transformedAssemblyPath);
                using var trapWriter = projectLayout.CreateTrapWriter(Logger, transformedAssemblyPath, options.TrapCompression, discardDuplicates: true);

                var skipExtraction = options.Cache && File.Exists(trapWriter.TrapFile);

                if (!skipExtraction)
                {
                    /* Note on parallel builds:
                     *
                     * The trap writer and source archiver both perform atomic moves
                     * of the file to the final destination.
                     *
                     * If the same source file or trap file are generated concurrently
                     * (by different parallel invocations of the extractor), then
                     * last one wins.
                     *
                     * Specifically, if two assemblies are analysed concurrently in a build,
                     * then there is a small amount of duplicated work but the output should
                     * still be correct.
                     */

                    // compilation.Clone() reduces memory footprint by allowing the symbols
                    // in c to be garbage collected.
                    Compilation c = compilation.Clone();


                    if (c.GetAssemblyOrModuleSymbol(r) is IAssemblySymbol assembly)
                    {
                        var cx = extractor.CreateContext(c, trapWriter, new AssemblyScope(assembly, assemblyPath, false), AddAssemblyTrapPrefix);

                        foreach (var module in assembly.Modules)
                        {
                            AnalyseNamespace(cx, module.GlobalNamespace);
                        }

                        Entities.Attribute.ExtractAttributes(cx, assembly, Extraction.Entities.Assembly.Create(cx, assembly.GetSymbolLocation()));

                        cx.PopulateAll();
                    }
                }

                ReportProgress(assemblyPath, trapWriter.TrapFile, stopwatch.Elapsed, skipExtraction ? AnalysisAction.UpToDate : AnalysisAction.Extracted);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Logger.Log(Severity.Error, "  Unhandled exception analyzing {0}: {1}", r.FilePath, ex);
            }
        }

        private void DoExtractCIL(PortableExecutableReference r)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();
            CIL.Entities.Assembly.ExtractCIL(layout, r.FilePath, Logger, !options.Cache, options.PDB, options.TrapCompression, out var trapFile, out var extracted);
            stopwatch.Stop();
            ReportProgress(r.FilePath, trapFile, stopwatch.Elapsed, extracted ? AnalysisAction.Extracted : AnalysisAction.UpToDate);
        }

        private void AnalyseNamespace(Context cx, INamespaceSymbol ns)
        {
            foreach (var memberNamespace in ns.GetNamespaceMembers())
            {
                AnalyseNamespace(cx, memberNamespace);
            }

            foreach (var memberType in ns.GetTypeMembers())
            {
                Entities.Type.Create(cx, memberType).ExtractRecursive();
            }
        }

        /// <summary>
        ///     Enqueue all reference analysis tasks.
        /// </summary>
        public void AnalyseReferences()
        {
            foreach (var r in compilation.References.OfType<PortableExecutableReference>())
            {
                AnalyseReferenceAssembly(r);
            }
        }

        // The bulk of the extraction work, potentially executed in parallel.
        private readonly List<Action> extractionTasks = new List<Action>();

        private void ReportProgress(string src, string output, TimeSpan time, AnalysisAction action)
        {
            lock (progressMutex)
                progressMonitor.Analysed(++taskCount, extractionTasks.Count, src, output, time, action);
        }

        private void DoExtractTree(SyntaxTree tree)
        {
            try
            {
                var stopwatch = new Stopwatch();
                stopwatch.Start();
                var sourcePath = tree.FilePath;
                var transformedSourcePath = PathTransformer.Transform(sourcePath);

                var projectLayout = layout.LookupProjectOrNull(transformedSourcePath);
                var excluded = projectLayout == null;
                var trapPath = excluded ? "" : projectLayout.GetTrapPath(Logger, transformedSourcePath, options.TrapCompression);
                var upToDate = false;

                if (!excluded)
                {
                    // compilation.Clone() is used to allow symbols to be garbage collected.
                    using var trapWriter = projectLayout.CreateTrapWriter(Logger, transformedSourcePath, options.TrapCompression, discardDuplicates: false);

                    upToDate = options.Fast && FileIsUpToDate(sourcePath, trapWriter.TrapFile);

                    if (!upToDate)
                    {
                        var cx = extractor.CreateContext(compilation.Clone(), trapWriter, new SourceScope(tree), AddAssemblyTrapPrefix);
                        Populators.CompilationUnit.Extract(cx, tree.GetRoot());
                        cx.PopulateAll();
                        cx.ExtractComments(cx.CommentGenerator);
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
                extractor.Message(new Message("Unhandled exception processing syntax tree", tree.FilePath, null, ex.StackTrace));
            }
        }

        /// <summary>
        /// Run all extraction tasks.
        /// </summary>
        /// <param name="numberOfThreads">The number of threads to use.</param>
        public void PerformExtraction(int numberOfThreads)
        {
            Parallel.Invoke(
                new ParallelOptions { MaxDegreeOfParallelism = numberOfThreads },
                extractionTasks.ToArray());
        }

        public void Dispose()
        {
            compilationTrapFile?.Dispose();

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
        public int ExtractorErrors => extractor == null ? 0 : extractor.Errors;

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

        /// <summary>
        /// Logs information about the extractor, as well as the arguments to Roslyn.
        /// </summary>
        /// <param name="roslynArgs">The arguments passed to Roslyn.</param>
        /// <returns>A Boolean indicating whether the same arguments have been logged previously.</returns>
        private bool LogRoslynArgs(IEnumerable<string> roslynArgs, string extractorVersion)
        {
            LogExtractorInfo(extractorVersion);
            Logger.Log(Severity.Info, $"  Arguments to Roslyn: {string.Join(' ', roslynArgs)}");

            var tempFile = Extractor.GetCSharpArgsLogPath(Path.GetRandomFileName());

            bool argsWritten;
            using (var streamWriter = new StreamWriter(new FileStream(tempFile, FileMode.Append, FileAccess.Write)))
            {
                streamWriter.WriteLine($"# Arguments to Roslyn: {string.Join(' ', roslynArgs.Where(arg => !arg.StartsWith('@')))}");
                argsWritten = roslynArgs.WriteCommandLine(streamWriter);
            }

            var hash = FileUtils.ComputeFileHash(tempFile);
            var argsFile = Extractor.GetCSharpArgsLogPath(hash);

            if (argsWritten)
                Logger.Log(Severity.Info, $"  Arguments have been written to {argsFile}");

            if (File.Exists(argsFile))
            {
                try
                {
                    File.Delete(tempFile);
                }
                catch (IOException e)
                {
                    Logger.Log(Severity.Warning, $"  Failed to remove {tempFile}: {e.Message}");
                }
                return false;
            }

            try
            {
                File.Move(tempFile, argsFile);
            }
            catch (IOException e)
            {
                Logger.Log(Severity.Warning, $"  Failed to move {tempFile} to {argsFile}: {e.Message}");
            }

            return true;
        }


        /// <summary>
        /// Logs detailed information about this invocation,
        /// in the event that errors were detected.
        /// </summary>
        /// <returns>A Boolean indicating whether to proceed with extraction.</returns>
        public void LogDiagnostics()
        {
            foreach (var error in FilteredDiagnostics)
            {
                Logger.Log(Severity.Error, "  Compilation error: {0}", error);
            }

            if (FilteredDiagnostics.Any())
            {
                foreach (var reference in compilation.References)
                {
                    Logger.Log(Severity.Info, "  Resolved reference {0}", reference.Display);
                }
            }
        }
    }

    /// <summary>
    /// What action was performed when extracting a file.
    /// </summary>
    public enum AnalysisAction
    {
        Extracted,
        UpToDate,
        Excluded
    }

    /// <summary>
    /// Callback for various extraction events.
    /// (Used for display of progress).
    /// </summary>
    public interface IProgressMonitor
    {
        /// <summary>
        /// Callback that a particular item has been analysed.
        /// </summary>
        /// <param name="item">The item number being processed.</param>
        /// <param name="total">The total number of items to process.</param>
        /// <param name="source">The name of the item, e.g. a source file.</param>
        /// <param name="output">The name of the item being output, e.g. a trap file.</param>
        /// <param name="time">The time to extract the item.</param>
        /// <param name="action">What action was taken for the file.</param>
        void Analysed(int item, int total, string source, string output, TimeSpan time, AnalysisAction action);

        /// <summary>
        /// A "using namespace" directive was seen but the given
        /// namespace could not be found.
        /// Only called once for each @namespace.
        /// </summary>
        /// <param name="namespace"></param>
        void MissingNamespace(string @namespace);

        /// <summary>
        /// An ErrorType was found.
        /// Called once for each type name.
        /// </summary>
        /// <param name="type">The full/partial name of the type.</param>
        void MissingType(string type);

        /// <summary>
        /// Report a summary of missing entities.
        /// </summary>
        /// <param name="types">The number of missing types.</param>
        /// <param name="namespaces">The number of missing using namespace declarations.</param>
        void MissingSummary(int types, int namespaces);
    }
}
