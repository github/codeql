using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.CSharp.DependencyFetching;
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
            ExtractionInput extractionInput,
            CommonOptions options,
            IProgressMonitor progressMonitor,
            Stopwatch stopwatch)
        {
            var output = FileUtils.CreateTemporaryFile(".dll", out var shouldCleanUpContainingFolder);

            try
            {
                CSharp.Extractor.Analyse(stopwatch, analyser, options,
                    references => GetResolvedReferencesStandalone(extractionInput.References, references),
                    (analyser, syntaxTrees) => CSharp.Extractor.ReadSyntaxTrees(extractionInput.Sources, analyser, null, null, syntaxTrees),
                    (syntaxTrees, references) => CSharpCompilation.Create(
                        output.Name, syntaxTrees, references, new CSharpCompilationOptions(OutputKind.ConsoleApplication, allowUnsafe: true)
                        ),
                    (compilation, options) => analyser.Initialize(output.FullName, extractionInput.CompilationInfos, compilation, options),
                    () =>
                    {
                        foreach (var type in analyser.ExtractionContext!.MissingNamespaces)
                        {
                            progressMonitor.MissingNamespace(type);
                        }

                        foreach (var type in analyser.ExtractionContext!.MissingTypes)
                        {
                            progressMonitor.MissingType(type);
                        }

                        progressMonitor.MissingSummary(analyser.ExtractionContext!.MissingTypes.Count(), analyser.ExtractionContext!.MissingNamespaces.Count());
                    });
            }
            finally
            {
                try
                {
                    if (shouldCleanUpContainingFolder)
                    {
                        FileUtils.TryDelete(output.FullName);
                    }
                }
                catch
                { }
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
                var extra = action switch
                {
                    AnalysisAction.Extracted => time.ToString(),
                    AnalysisAction.Excluded => "excluded",
                    AnalysisAction.UpToDate => "up to date",
                    _ => "unknown action"
                };
                logger.LogDebug($"[{item}/{total}] {source} ({extra})");
            }

            public void Started(int item, int total, string source)
            {
                logger.LogDebug($"[{item}/{total}] {source} (processing started)");
            }

            public void MissingType(string type)
            {
                logger.LogDebug($"Missing type {type}");
            }

            public void MissingNamespace(string @namespace)
            {
                logger.LogInfo($"Missing namespace {@namespace}");
            }

            public void MissingSummary(int missingTypes, int missingNamespaces)
            {
                if (missingTypes > 0 || missingNamespaces > 0)
                {
                    logger.LogInfo($"Failed to resolve {missingTypes} types in {missingNamespaces} namespaces");
                }
            }
        }

        public record ExtractionInput(IEnumerable<string> Sources, IEnumerable<string> References, IEnumerable<(string, string)> CompilationInfos);

        public static ExitCode Run(Options options)
        {
            var overallStopwatch = new Stopwatch();
            overallStopwatch.Start();

            using var logger = new ConsoleLogger(options.Verbosity, logThreadId: true);
            logger.Log(Severity.Info, "Extracting C# with build-mode set to 'none'");
            using var dependencyManager = new DependencyManager(options.SrcDir, logger);

            if (!dependencyManager.NonGeneratedSourcesFiles.Any())
            {
                logger.Log(Severity.Error, "No source files found");
                return ExitCode.Errors;
            }

            using var fileLogger = CSharp.Extractor.MakeLogger(options.Verbosity, false);

            logger.Log(Severity.Info, "");
            logger.Log(Severity.Info, "Extracting...");

            var analyzerStopwatch = new Stopwatch();
            analyzerStopwatch.Start();

            var canonicalPathCache = CanonicalPathCache.Create(fileLogger, 1000);
            var pathTransformer = new PathTransformer(canonicalPathCache);

            var progressMonitor = new ExtractionProgress(logger);
            using var analyser = new StandaloneAnalyser(progressMonitor, fileLogger, pathTransformer, canonicalPathCache, false);
            try
            {
                var extractionInput = new ExtractionInput(dependencyManager.AllSourceFiles, dependencyManager.ReferenceFiles, dependencyManager.CompilationInfos);
                AnalyseStandalone(analyser, extractionInput, options, progressMonitor, analyzerStopwatch);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                fileLogger.LogError($"  Unhandled exception: {ex}");
            }

            logger.Log(Severity.Info, $"Extraction completed in {overallStopwatch.Elapsed}");

            return ExitCode.Ok;
        }
    }
}
