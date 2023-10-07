using System;
using System.Collections.Generic;
using Semmle.Util.Logging;
using Semmle.Extraction.CSharp.DependencyFetching;

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
            dependencyManager = new DependencyManager(options.SrcDir, options.Dependencies, logger);
            References = dependencyManager.ReferenceFiles;
            Extraction = new Extraction(options.SrcDir);
            Extraction.Sources.AddRange(options.Dependencies.SolutionFile is null ? dependencyManager.AllSourceFiles : dependencyManager.ProjectSourceFiles);
        }

        public IEnumerable<string> References { get; }

        /// <summary>
        /// The extraction configuration.
        /// </summary>
        public Extraction Extraction { get; }

        private readonly DependencyManager dependencyManager;

        public void Dispose()
        {
            dependencyManager.Dispose();
        }
    };

    public class Program
    {
        public static int Main(string[] args)
        {
            CSharp.Extractor.SetInvariantCulture();

            var options = Options.Create(args);

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
