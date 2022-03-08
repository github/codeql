using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.Standalone
{
    public static class Extractor
    {

        private static IEnumerable<Action> GetResolvedReferencesStandalone(IEnumerable<string> referencePaths, BlockingCollection<MetadataReference> references)
        {
            return referencePaths.Select<string, Action>(path => () =>
            {
                var reference = MetadataReference.CreateFromFile(path);
                references.Add(reference);
            });
        }

        private static void AnalyseStandalone(
            StandaloneAnalyser analyser,
            IEnumerable<string> sources,
            IEnumerable<string> referencePaths,
            CommonOptions options,
            IProgressMonitor progressMonitor,
            Stopwatch stopwatch)
        {
            CSharp.Extractor.Analyse(stopwatch, analyser, options,
                references => GetResolvedReferencesStandalone(referencePaths, references),
                (analyser, syntaxTrees) => CSharp.Extractor.ReadSyntaxTrees(sources, analyser, null, null, syntaxTrees),
                (syntaxTrees, references) => CSharpCompilation.Create("csharp.dll", syntaxTrees, references),
                (compilation, options) => analyser.Initialize(compilation, options),
                () => { },
                _ => { },
                () =>
                {
                    foreach (var type in analyser.MissingNamespaces)
                    {
                        progressMonitor.MissingNamespace(type);
                    }

                    foreach (var type in analyser.MissingTypes)
                    {
                        progressMonitor.MissingType(type);
                    }

                    progressMonitor.MissingSummary(analyser.MissingTypes.Count(), analyser.MissingNamespaces.Count());
                });
        }

        private static void ExtractStandalone(
            IEnumerable<string> sources,
            IEnumerable<string> referencePaths,
            IProgressMonitor pm,
            ILogger logger,
            CommonOptions options)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
            var pathTransformer = new PathTransformer(canonicalPathCache);

            using var analyser = new StandaloneAnalyser(pm, logger, false, pathTransformer);
            try
            {
                AnalyseStandalone(analyser, sources, referencePaths, options, pm, stopwatch);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                analyser.Logger.Log(Severity.Error, "  Unhandled exception: {0}", ex);
            }
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
                using var fileLogger = CSharp.Extractor.MakeLogger(options.Verbosity, false);

                logger.Log(Severity.Info, "");
                logger.Log(Severity.Info, "Extracting...");
                ExtractStandalone(
                    a.Extraction.Sources,
                    a.References,
                    new ExtractionProgress(logger),
                    fileLogger,
                    options);
                logger.Log(Severity.Info, $"Extraction completed in {stopwatch.Elapsed}");
            }

            return ExitCode.Ok;
        }
    }
}