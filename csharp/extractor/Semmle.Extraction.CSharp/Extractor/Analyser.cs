using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Util;
using Semmle.Util.Logging;
using Semmle.Extraction.CSharp.Populators;
using System.Reflection;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Encapsulates a C# analysis task.
    /// </summary>
    public class Analyser : IDisposable
    {
        public ExtractionContext? ExtractionContext { get; protected set; }
        protected CSharpCompilation? compilation;
        protected CommonOptions? options;
        private protected Entities.Compilation? compilationEntity;
        private IDisposable? compilationTrapFile;

        // The bulk of the extraction work, potentially executed in parallel.
        protected readonly List<Action> extractionTasks = new List<Action>();
        private int taskCount = 0;

        private readonly Stopwatch stopWatch = new Stopwatch();

        private readonly IProgressMonitor progressMonitor;

        public ILogger Logger { get; }

        protected readonly bool addAssemblyTrapPrefix;

        public PathTransformer PathTransformer { get; }

        public IPathCache PathCache { get; }

        protected Analyser(
            IProgressMonitor pm,
            ILogger logger,
            PathTransformer pathTransformer,
            IPathCache pathCache,
            bool addAssemblyTrapPrefix)
        {
            Logger = logger;
            PathTransformer = pathTransformer;
            PathCache = pathCache;
            this.addAssemblyTrapPrefix = addAssemblyTrapPrefix;
            this.progressMonitor = pm;

            Logger.LogInfo($"EXTRACTION STARTING at {DateTime.Now}");
            stopWatch.Start();
        }

        /// <summary>
        /// Perform an analysis on a source file/syntax tree.
        /// </summary>
        /// <param name="tree">Syntax tree to analyse.</param>
        public void AnalyseTree(SyntaxTree tree)
        {
            extractionTasks.Add(() => DoExtractTree(tree));
        }

#nullable disable warnings

        /// <summary>
        ///     Enqueue all reference analysis tasks.
        /// </summary>
        public void AnalyseReferences()
        {
            foreach (var assembly in compilation.References.OfType<PortableExecutableReference>())
            {
                extractionTasks.Add(() => DoAnalyseReferenceAssembly(assembly));
            }
        }

        /// <summary>
        ///     Constructs the map from assembly string to its filename.
        ///
        ///     Roslyn doesn't record the relationship between a filename and its assembly
        ///     information, so we need to retrieve this information manually.
        /// </summary>
        protected void SetReferencePaths()
        {
            foreach (var reference in compilation.References.OfType<PortableExecutableReference>())
            {
                try
                {
                    var refPath = reference.FilePath!;

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
                        assemblyIdentity = $"{reader.GetString(def.Name)} {def.Version}";
                    }
                    ExtractionContext.SetAssemblyFile(assemblyIdentity, refPath);

                }
                catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
                {
                    ExtractionContext.Message(new Message("Exception reading reference file", reference.FilePath, null, ex.StackTrace));
                }
            }
        }

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

                var assemblyPath = r.FilePath!;
                var transformedAssemblyPath = PathTransformer.Transform(assemblyPath);
                using var trapWriter = transformedAssemblyPath.CreateTrapWriter(Logger, options.TrapCompression, discardDuplicates: true);

                var skipExtraction = options.Cache && File.Exists(trapWriter.TrapFile);

                var currentTaskId = IncrementTaskCount();
                ReportProgressTaskStarted(currentTaskId, assemblyPath);

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

                    if (compilation.GetAssemblyOrModuleSymbol(r) is IAssemblySymbol assembly)
                    {
                        var cx = new Context(ExtractionContext, compilation, trapWriter, new AssemblyScope(assembly, assemblyPath), addAssemblyTrapPrefix);

                        foreach (var module in assembly.Modules)
                        {
                            AnalyseNamespace(cx, module.GlobalNamespace);
                        }

                        Entities.Attribute.ExtractAttributes(cx, assembly, Entities.Assembly.Create(cx, assembly.GetSymbolLocation()));

                        cx.PopulateAll();
                    }
                }

                ReportProgressTaskDone(currentTaskId, assemblyPath, trapWriter.TrapFile, stopwatch.Elapsed, skipExtraction ? AnalysisAction.UpToDate : AnalysisAction.Extracted);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Logger.LogError($"  Unhandled exception analyzing {r.FilePath}: {ex}");
            }
        }

        private void DoExtractTree(SyntaxTree tree)
        {
            try
            {
                var stopwatch = new Stopwatch();
                stopwatch.Start();
                var sourcePath = BinaryLogExtractionContext.GetAdjustedPath(ExtractionContext, tree.FilePath) ?? tree.FilePath;

                var transformedSourcePath = PathTransformer.Transform(sourcePath);

                var trapPath = transformedSourcePath.GetTrapPath(Logger, options.TrapCompression);
                var upToDate = false;

                // compilation.Clone() is used to allow symbols to be garbage collected.
                using var trapWriter = transformedSourcePath.CreateTrapWriter(Logger, options.TrapCompression, discardDuplicates: false);

                upToDate = FileIsUpToDate(sourcePath, trapWriter.TrapFile);

                var currentTaskId = IncrementTaskCount();
                ReportProgressTaskStarted(currentTaskId, sourcePath);

                if (!upToDate)
                {
                    var cx = new Context(ExtractionContext, compilation, trapWriter, new SourceScope(tree), addAssemblyTrapPrefix);
                    // Ensure that the file itself is populated in case the source file is totally empty
                    var root = tree.GetRoot();
                    Entities.File.Create(cx, root.SyntaxTree.FilePath);

                    var csNode = (CSharpSyntaxNode)root;
                    var directiveVisitor = new DirectiveVisitor(cx);
                    csNode.Accept(directiveVisitor);
                    foreach (var branch in directiveVisitor.BranchesTaken)
                    {
                        cx.TrapStackSuffix.Add(branch);
                    }
                    csNode.Accept(new CompilationUnitVisitor(cx));
                    cx.PopulateAll();
                    CommentPopulator.ExtractCommentBlocks(cx, cx.CommentGenerator);
                    cx.PopulateAll();
                }

                ReportProgressTaskDone(currentTaskId, sourcePath, trapPath, stopwatch.Elapsed, upToDate ? AnalysisAction.UpToDate : AnalysisAction.Extracted);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                ExtractionContext.Message(new Message($"Unhandled exception processing syntax tree. {ex.Message}", tree.FilePath, null, ex.StackTrace));
            }
        }

        private void DoAnalyseCompilation()
        {
            try
            {
                var assemblyPath = ExtractionContext.OutputPath;
                var stopwatch = new Stopwatch();
                stopwatch.Start();
                var currentTaskId = IncrementTaskCount();
                ReportProgressTaskStarted(currentTaskId, assemblyPath);

                var transformedAssemblyPath = PathTransformer.Transform(assemblyPath);
                var assembly = compilation.Assembly;
                var trapWriter = transformedAssemblyPath.CreateTrapWriter(Logger, options.TrapCompression, discardDuplicates: false);
                compilationTrapFile = trapWriter;  // Dispose later
                var cx = new Context(ExtractionContext, compilation, trapWriter, new AssemblyScope(assembly, assemblyPath), addAssemblyTrapPrefix);

                compilationEntity = Entities.Compilation.Create(cx);

                ExtractionContext.CompilationInfos.ForEach(ci => trapWriter.Writer.compilation_info(compilationEntity, ci.key, ci.value));

                ReportProgressTaskDone(currentTaskId, assemblyPath, trapWriter.TrapFile, stopwatch.Elapsed, AnalysisAction.Extracted);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Logger.LogError($"  Unhandled exception analyzing compilation: {ex}");
            }
        }

        public void LogPerformance(Entities.PerformanceMetrics p) => compilationEntity.PopulatePerformance(p);

#nullable restore warnings

        /// <summary>
        /// Extracts compilation-wide entities, such as compilations and compiler diagnostics.
        /// </summary>
        public void AnalyseCompilation()
        {
            extractionTasks.Add(() => DoAnalyseCompilation());
        }

        private static bool FileIsUpToDate(string src, string dest)
        {
            return File.Exists(dest) &&
                File.GetLastWriteTime(dest) >= File.GetLastWriteTime(src);
        }

        private static void AnalyseNamespace(Context cx, INamespaceSymbol ns)
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

        private int IncrementTaskCount()
        {
            return Interlocked.Increment(ref taskCount);
        }

        private void ReportProgressTaskStarted(int currentCount, string src)
        {
            progressMonitor.Started(currentCount, extractionTasks.Count, src);
        }

        private void ReportProgressTaskDone(int currentCount, string src, string output, TimeSpan time, AnalysisAction action)
        {
            progressMonitor.Analysed(currentCount, extractionTasks.Count, src, output, time, action);
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

        public virtual void Dispose()
        {
            stopWatch.Stop();
            Logger.LogInfo($"  Peak working set = {Process.GetCurrentProcess().PeakWorkingSet64 / (1024 * 1024)} MB");

            if (TotalErrors > 0)
                Logger.LogInfo($"EXTRACTION FAILED with {TotalErrors} error{(TotalErrors == 1 ? "" : "s")} in {stopWatch.Elapsed}");
            else
                Logger.LogInfo($"EXTRACTION SUCCEEDED in {stopWatch.Elapsed}");

            compilationTrapFile?.Dispose();
        }

        /// <summary>
        /// Number of errors encountered during extraction.
        /// </summary>
        private int ExtractorErrors => ExtractionContext?.Errors ?? 0;

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
        public void LogExtractorInfo()
        {
            Logger.LogInfo($"  Extractor: {Environment.GetCommandLineArgs()[0]}");
            Logger.LogInfo($"  Extractor version: {Version}");
            Logger.LogInfo($"  Current working directory: {Directory.GetCurrentDirectory()}");
        }

        private static string Version
        {
            get
            {
                // the attribute for the git information are always attached to the entry assembly by our build system
                var assembly = Assembly.GetEntryAssembly();
                var versionString = assembly?.GetCustomAttribute<AssemblyInformationalVersionAttribute>();
                if (versionString == null)
                {
                    return "unknown (not built from internal bazel workspace)";
                }
                return versionString.InformationalVersion;
            }
        }
    }
}
