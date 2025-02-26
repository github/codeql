using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Extraction.PowerShell;
using Semmle.Util.Logging;

namespace Semmle.Extraction.PowerShell.Standalone
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

    public class Program
    {
        public static int Main(string[] args)
        {
            PowerShell.Extractor.Extractor.SetInvariantCulture();

            var options = Options.Create(args);
            using var output = new ConsoleLogger(options.Verbosity);

            if (options.Help)
            {
                Options.ShowHelp(System.Console.Out);
                return 0;
            }

            if (options.Errors)
                // Something went wrong
                // https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/exit-codes
                return 2;

            var start = DateTime.Now;

            output.Log(Severity.Info, "Running PowerShell standalone extractor");
            var sourceFiles = options
                .Files.Where(d =>
                    options.Extensions.Contains(
                        d.Extension,
                        StringComparer.InvariantCultureIgnoreCase
                    )
                )
                .Select(d => d.FullName)
                .Where(d => !options.ExcludesFile(d))
                .ToArray();

            var sourceFileCount = sourceFiles.Length;

            if (sourceFileCount == 0)
            {
                output.Log(Severity.Error, "No source files found");
                // No source files found
                // https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/exit-codes
                return 32;
            }

            if (!options.SkipExtraction)
            {
                using var fileLogger = new FileLogger(
                    options.Verbosity,
                    PowerShell.Extractor.Extractor.GetPowerShellLogPath()
                );

                output.Log(Severity.Info, "");
                output.Log(Severity.Info, "Extracting...");
                options.TrapCompression = TrapWriter.CompressionMode.None;
                PowerShell.Extractor.Extractor.ExtractStandalone(
                    sourceFiles,
                    new ExtractionProgress(output),
                    fileLogger,
                    options
                );
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

            public void Analysed(
                int item,
                int total,
                string source,
                string output,
                TimeSpan time,
                AnalysisAction action
            )
            {
                logger.Log(
                    Severity.Info,
                    "[{0}/{1}] {2} ({3})",
                    item,
                    total,
                    source,
                    action == AnalysisAction.Extracted
                        ? time.ToString()
                        : action == AnalysisAction.Excluded
                            ? "excluded"
                            : "up to date"
                );
            }
        }
    }
}
