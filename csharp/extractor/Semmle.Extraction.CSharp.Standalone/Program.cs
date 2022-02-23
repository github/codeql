using System;
using System.Collections.Generic;
using System.Diagnostics;
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
            Extraction.Sources.AddRange(options.SolutionFile is null ? buildAnalysis.AllSourceFiles : buildAnalysis.ProjectSourceFiles);
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
        public static ExitCode Run(Options options)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            using var logger = new ConsoleLogger(options.Verbosity);
            logger.Log(Severity.Info, "Running C# standalone extractor");
            using var a = new Analysis(logger, options);
            var sourceFileCount = a.Extraction.Sources.Count;

            if (sourceFileCount == 0)
            {
                logger.Log(Severity.Error, "No source files found");
                return ExitCode.Errors;
            }

            if (!options.SkipExtraction)
            {
                using var fileLogger = Extractor.MakeLogger(options.Verbosity, false);

                logger.Log(Severity.Info, "");
                logger.Log(Severity.Info, "Extracting...");
                Extractor.ExtractStandalone(
                    a.Extraction.Sources,
                    a.References,
                    new ExtractionProgress(logger),
                    fileLogger,
                    options);
                logger.Log(Severity.Info, $"Extraction completed in {stopwatch.Elapsed}");
            }
            return ExitCode.Ok;
        }

        public static int Main(string[] args)
        {
            Extractor.SetInvariantCulture();

            var options = Options.Create(args);
            // options.CIL = true;  // To do: Enable this

            if (options.Help)
            {
                Options.ShowHelp(System.Console.Out);
                return 0;
            }

            if (options.Errors)
                return 1;

            return (int)Run(options);
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
