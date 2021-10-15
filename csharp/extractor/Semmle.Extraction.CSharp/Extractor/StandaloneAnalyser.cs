using Microsoft.CodeAnalysis.CSharp;
using System.Collections.Generic;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    public class StandaloneAnalyser : Analyser
    {
        public StandaloneAnalyser(IProgressMonitor pm, ILogger logger, bool addAssemblyTrapPrefix, PathTransformer pathTransformer)
            : base(pm, logger, addAssemblyTrapPrefix, pathTransformer)
        {
        }

        public void InitializeStandalone(CSharpCompilation compilationIn, CommonOptions options)
        {
            compilation = compilationIn;
            layout = new Layout();
            extractor = new StandaloneExtractor(Logger, PathTransformer);
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
