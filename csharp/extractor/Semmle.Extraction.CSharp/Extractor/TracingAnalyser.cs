using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    public class TracingAnalyser : Analyser
    {
        private bool init;

        public TracingAnalyser(IProgressMonitor pm, ILogger logger, PathTransformer pathTransformer, IPathCache pathCache, bool addAssemblyTrapPrefix)
            : base(pm, logger, pathTransformer, pathCache, addAssemblyTrapPrefix)
        {
        }

        /// <summary>
        /// Start initialization of the analyser.
        /// </summary>
        /// <param name="roslynArgs">The arguments passed to Roslyn.</param>
        /// <returns>A Boolean indicating whether to proceed with extraction.</returns>
        public bool BeginInitialize(IEnumerable<string> roslynArgs)
        {
            LogExtractorInfo();
            return init = LogRoslynArgs(roslynArgs);
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
           CSharpCompilation compilation,
           string cwd,
           string[] args)
        {
            if (!init)
                throw new InternalError("EndInitialize called without BeginInitialize returning true");
            this.options = options;
            this.compilation = compilation;
            this.ExtractionContext = new ExtractionContext(cwd, args, GetOutputName(compilation, commandLineArguments), [], Logger, PathTransformer, ExtractorMode.None, options.QlTest);
            var errorCount = LogDiagnostics();

            SetReferencePaths();

            CompilationErrors += errorCount;
        }

        /// <summary>
        /// Logs information about the extractor, as well as the arguments to Roslyn.
        /// </summary>
        /// <param name="roslynArgs">The arguments passed to Roslyn.</param>
        /// <returns>A Boolean indicating whether the same arguments have been logged previously.</returns>
        private bool LogRoslynArgs(IEnumerable<string> roslynArgs)
        {
            Logger.LogInfo($"  Arguments to Roslyn: {string.Join(' ', roslynArgs)}");

            var tempFile = Extractor.GetCSharpArgsLogPath(Path.GetRandomFileName());

            bool argsWritten;
            using (var streamWriter = new StreamWriter(new FileStream(tempFile, FileMode.Append, FileAccess.Write)))
            {
                streamWriter.WriteLine($"# Arguments to Roslyn: {string.Join(' ', roslynArgs.Where(arg => !CommandLineExtensions.IsFileArgument(arg)))}");
                argsWritten = streamWriter.WriteContentFromArgumentFile(roslynArgs);
            }

            var hash = FileUtils.ComputeFileHash(tempFile);
            var argsFile = Extractor.GetCSharpArgsLogPath(hash);

            if (argsWritten)
                Logger.LogInfo($"  Arguments have been written to {argsFile}");

            if (File.Exists(argsFile))
            {
                try
                {
                    File.Delete(tempFile);
                }
                catch (IOException e)
                {
                    Logger.LogWarning($"  Failed to remove {tempFile}: {e.Message}");
                }
                return false;
            }

            try
            {
                File.Move(tempFile, argsFile);
            }
            catch (IOException e)
            {
                Logger.LogWarning($"  Failed to move {tempFile} to {argsFile}: {e.Message}");
            }

            return true;
        }

        /// <summary>
        /// Determine the path of the output dll/exe.
        /// </summary>
        internal static string GetOutputName(CSharpCompilation compilation,
            CommandLineArguments commandLineArguments)
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

                var entryPointFilename = entry.Locations.Best().SourceTree!.FilePath;
                return Path.ChangeExtension(entryPointFilename, ".exe");
            }

            return Path.Combine(commandLineArguments.OutputDirectory, commandLineArguments.OutputFileName);
        }

        private int LogDiagnostics()
        {
            var filteredDiagnostics = compilation!
                .GetDiagnostics()
                .Where(e => e.Severity >= DiagnosticSeverity.Error && !errorsToIgnore.Contains(e.Id))
                .ToList();

            foreach (var error in filteredDiagnostics)
            {
                Logger.LogError($"  Compilation error: {error}");
            }

            if (filteredDiagnostics.Count != 0)
            {
                foreach (var reference in compilation.References)
                {
                    Logger.LogInfo($"  Resolved reference {reference.Display}");
                }
            }

            return filteredDiagnostics.Count;
        }

        private static readonly HashSet<string> errorsToIgnore = new HashSet<string>
        {
            "CS7027",   // Code signing failure
            "CS1589",   // XML referencing not supported
            "CS1569"    // Error writing XML documentation
        };
    }
}
