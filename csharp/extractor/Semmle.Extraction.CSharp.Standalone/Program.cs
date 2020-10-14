using System;
using System.Collections.Generic;
using Semmle.BuildAnalyser;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.Standalone
{
    /// <summary>
    ///     One independent run of the extractor.
    /// </summary>
    internal class Extraction
    {
        public Extraction(string directory)
        {
            Directory = directory;
        }

        public string Directory { get; }
        public List<string> Sources { get; } = new List<string>();
    };

    /// <summary>
    ///     Searches for source/references and creates separate extractions.
    /// </summary>
    internal sealed class Analysis : IDisposable
    {
        public Analysis(ILogger logger, Options options)
        {
            var progressMonitor = new ProgressMonitor(logger);
            buildAnalysis = new BuildAnalysis(options, progressMonitor);
            References = buildAnalysis.ReferenceFiles;
            Extraction = new Extraction(options.SrcDir);
            Extraction.Sources.AddRange(options.SolutionFile == null ? buildAnalysis.AllSourceFiles : buildAnalysis.ProjectSourceFiles);
        }

        public IEnumerable<string> References { get; }

        /// <summary>
        /// The extraction configuration.
        /// </summary>
        public Extraction Extraction { get; }

        private readonly BuildAnalysis buildAnalysis;

        public void Dispose()
        {
            buildAnalysis.Dispose();
        }
    };

    public class Program
    {
        public static int Main(string[] args)
        {
            var options = Options.Create(args);
            // options.CIL = true;  // To do: Enable this
            using var output = new ConsoleLogger(options.Verbosity);

            if (options.Help)
            {
                Options.ShowHelp(System.Console.Out);
                return 0;
            }

            if (options.Errors)
                return 1;

            var start = DateTime.Now;

            output.Log(Severity.Info, "Running C# standalone extractor");
            using var a = new Analysis(output, options);
            var sourceFileCount = a.Extraction.Sources.Count;

            if (sourceFileCount == 0)
            {
                output.Log(Severity.Error, "No source files found");
                return 1;
            }

            if (!options.SkipExtraction)
            {
                using var fileLogger = new FileLogger(options.Verbosity, Extractor.GetCSharpLogPath());

                output.Log(Severity.Info, "");
                output.Log(Severity.Info, "Extracting...");
                Extractor.ExtractStandalone(
                    a.Extraction.Sources,
                    a.References,
                    new ExtractionProgress(output),
                    fileLogger,
                    options);
                output.Log(Severity.Info, $"Extraction completed in {DateTime.Now - start}");
            }

            return 0;
        }

        private class ExtractionProgress : IProgressMonitor
        {
            public ExtractionProgress(ILogger output)
            {
                logger = output;
            }

            private readonly ILogger logger;

            public void Analysed(int item, int total, string source, string output, TimeSpan time, AnalysisAction action)
            {
                logger.Log(Severity.Info, "[{0}/{1}] {2} ({3})", item, total, source,
                    action == AnalysisAction.Extracted
                        ? time.ToString()
                        : action == AnalysisAction.Excluded
                            ? "excluded"
                            : "up to date");
            }

            public void MissingType(string type)
            {
                logger.Log(Severity.Debug, "Missing type {0}", type);
            }

            public void MissingNamespace(string @namespace)
            {
                logger.Log(Severity.Info, "Missing namespace {0}", @namespace);
            }

            public void MissingSummary(int missingTypes, int missingNamespaces)
            {
                logger.Log(Severity.Info, "Failed to resolve {0} types in {1} namespaces", missingTypes, missingNamespaces);
            }
        }
    }
}
