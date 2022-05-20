using System;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using Semmle.Util.Logging;
using Semmle.Util;


namespace Semmle.Extraction.CSharp
{
    public class TracingAnalyser : Analyser, IDisposable
    {
        private Entities.Compilation? compilationEntity;
        private IDisposable? compilationTrapFile;

        private bool init;

        public TracingAnalyser(IProgressMonitor pm, ILogger logger, bool addAssemblyTrapPrefix, PathTransformer pathTransformer)
            : base(pm, logger, addAssemblyTrapPrefix, pathTransformer)
        {
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
           CommonOptions options,
           CSharpCompilation compilation)
        {
            if (!init)
                throw new InternalError("EndInitialize called without BeginInitialize returning true");
            this.options = options;
            this.compilation = compilation;
            this.extractor = new TracingExtractor(GetOutputName(compilation, commandLineArguments), Logger, PathTransformer, options);
            LogDiagnostics();

            SetReferencePaths();

            CompilationErrors += FilteredDiagnostics.Count();
        }

        public override void Dispose()
        {
            compilationTrapFile?.Dispose();
            base.Dispose();
        }

        /// <summary>
        /// Extracts compilation-wide entities, such as compilations and compiler diagnostics.
        /// </summary>
        public void AnalyseCompilation()
        {
            extractionTasks.Add(() => DoAnalyseCompilation());
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

            if (commandLineArguments.OutputFileName is null)
            {
                // No output specified: Use name based on first filename
                var entry = compilation.GetEntryPoint(System.Threading.CancellationToken.None);
                if (entry is null)
                {
                    if (compilation.SyntaxTrees.Length == 0)
                        throw new InvalidOperationException("No source files seen");

                    // Probably invalid, but have a go anyway.
                    var entryPointFile = compilation.SyntaxTrees.First().FilePath;
                    return Path.ChangeExtension(entryPointFile, ".exe");
                }

                var entryPointFilename = entry.Locations.First().SourceTree!.FilePath;
                return Path.ChangeExtension(entryPointFilename, ".exe");
            }

            return Path.Combine(commandLineArguments.OutputDirectory, commandLineArguments.OutputFileName);
        }

#nullable disable warnings

        /// <summary>
        /// Logs detailed information about this invocation,
        /// in the event that errors were detected.
        /// </summary>
        /// <returns>A Boolean indicating whether to proceed with extraction.</returns>
        private void LogDiagnostics()
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

        private static readonly HashSet<string> errorsToIgnore = new HashSet<string>
        {
            "CS7027",   // Code signing failure
            "CS1589",   // XML referencing not supported
            "CS1569"    // Error writing XML documentation
        };

        private IEnumerable<Diagnostic> FilteredDiagnostics
        {
            get
            {
                return extractor is null || extractor.Mode.HasFlag(ExtractorMode.Standalone) || compilation is null ? Enumerable.Empty<Diagnostic>() :
                    compilation.
                    GetDiagnostics().
                    Where(e => e.Severity >= DiagnosticSeverity.Error && !errorsToIgnore.Contains(e.Id));
            }
        }

        private void DoAnalyseCompilation()
        {
            try
            {
                var assemblyPath = ((TracingExtractor?)extractor).OutputPath;
                var transformedAssemblyPath = PathTransformer.Transform(assemblyPath);
                var assembly = compilation.Assembly;
                var trapWriter = transformedAssemblyPath.CreateTrapWriter(Logger, options.TrapCompression, discardDuplicates: false);
                compilationTrapFile = trapWriter;  // Dispose later
                var cx = new Context(extractor, compilation.Clone(), trapWriter, new AssemblyScope(assembly, assemblyPath), addAssemblyTrapPrefix);

                compilationEntity = Entities.Compilation.Create(cx);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Logger.Log(Severity.Error, "  Unhandled exception analyzing {0}: {1}", "compilation", ex);
            }
        }

        public void LogPerformance(Entities.PerformanceMetrics p) => compilationEntity.PopulatePerformance(p);

#nullable restore warnings
    }
}
