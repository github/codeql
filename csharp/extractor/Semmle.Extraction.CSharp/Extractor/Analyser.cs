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

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Encapsulates a C# analysis task.
    /// </summary>
    public class Analyser : IDisposable
    {
        protected Extraction.Extractor? extractor;
        protected CSharpCompilation? compilation;
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

        protected Analyser(IProgressMonitor pm, ILogger logger, bool addAssemblyTrapPrefix, PathTransformer pathTransformer)
        {
            Logger = logger;
            this.addAssemblyTrapPrefix = addAssemblyTrapPrefix;
            Logger.Log(Severity.Info, "EXTRACTION STARTING at {0}", DateTime.Now);
            stopWatch.Start();
            progressMonitor = pm;
            PathTransformer = pathTransformer;
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
                // CIL first - it takes longer.
                if (options.CIL)
                    extractionTasks.Add(() => DoExtractCIL(assembly));
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
                        var cx = new Context(extractor, c, trapWriter, new AssemblyScope(assembly, assemblyPath), addAssemblyTrapPrefix);

                        foreach (var module in assembly.Modules)
                        {
                            AnalyseNamespace(cx, module.GlobalNamespace);
                        }

                        Entities.Attribute.ExtractAttributes(cx, assembly, Entities.Assembly.Create(cx, assembly.GetSymbolLocation()));

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
            CIL.Analyser.ExtractCIL(r.FilePath!, Logger, options, out var trapFile, out var extracted);
            stopwatch.Stop();
            ReportProgress(r.FilePath, trapFile, stopwatch.Elapsed, extracted ? AnalysisAction.Extracted : AnalysisAction.UpToDate);
        }

        private void DoExtractTree(SyntaxTree tree)
        {
            try
            {
                var stopwatch = new Stopwatch();
                stopwatch.Start();
                var sourcePath = tree.FilePath;
                var transformedSourcePath = PathTransformer.Transform(sourcePath);

                var trapPath = transformedSourcePath.GetTrapPath(Logger, options.TrapCompression);
                var upToDate = false;

                // compilation.Clone() is used to allow symbols to be garbage collected.
                using var trapWriter = transformedSourcePath.CreateTrapWriter(Logger, options.TrapCompression, discardDuplicates: false);

                upToDate = options.Fast && FileIsUpToDate(sourcePath, trapWriter.TrapFile);

                if (!upToDate)
                {
                    var cx = new Context(extractor, compilation.Clone(), trapWriter, new SourceScope(tree), addAssemblyTrapPrefix);
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

                ReportProgress(sourcePath, trapPath, stopwatch.Elapsed, upToDate ? AnalysisAction.UpToDate : AnalysisAction.Extracted);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                extractor.Message(new Message($"Unhandled exception processing syntax tree. {ex.Message}", tree.FilePath, null, ex.StackTrace));
            }
        }

#nullable restore warnings

        private static bool FileIsUpToDate(string src, string dest)
        {
            return File.Exists(dest) &&
                File.GetLastWriteTime(dest) >= File.GetLastWriteTime(src);
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

        private void ReportProgress(string src, string output, TimeSpan time, AnalysisAction action)
        {
            lock (progressMutex)
                progressMonitor.Analysed(++taskCount, extractionTasks.Count, src, output, time, action);
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
