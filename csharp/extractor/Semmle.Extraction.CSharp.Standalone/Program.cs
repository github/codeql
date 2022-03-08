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
        public static int Main(string[] args)
        {
            CSharp.Extractor.SetInvariantCulture();

            var options = Options.Create(args);
            // options.CIL = true;  // To do: Enable this

            if (options.Help)
            {
                Options.ShowHelp(System.Console.Out);
                return 0;
            }

            if (options.Errors)
                return 1;

            return (int)Extractor.Run(options);
        }
    }
}
