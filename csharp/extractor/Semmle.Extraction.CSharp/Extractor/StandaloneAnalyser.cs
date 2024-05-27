using System;
using System.Collections.Generic;
using System.IO;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    public class StandaloneAnalyser : Analyser
    {
        public StandaloneAnalyser(IProgressMonitor pm, ILogger logger, bool addAssemblyTrapPrefix, PathTransformer pathTransformer)
            : base(pm, logger, addAssemblyTrapPrefix, pathTransformer)
        {
        }

        public void Initialize(string outputPath, IEnumerable<(string, string)> compilationInfos, CSharpCompilation compilationIn, CommonOptions options)
        {
            compilation = compilationIn;
            extractor = new StandaloneExtractor(Directory.GetCurrentDirectory(), outputPath, compilationInfos, Logger, PathTransformer, options);
            this.options = options;
            LogExtractorInfo(Extraction.Extractor.Version);
            SetReferencePaths();
        }

#nullable disable warnings

        public IEnumerable<string> MissingTypes => extractor.MissingTypes;

        public IEnumerable<string> MissingNamespaces => extractor.MissingNamespaces;

#nullable restore warnings
    }
}
