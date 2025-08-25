using System.Collections.Generic;
using System.IO;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    public class StandaloneAnalyser : Analyser
    {
        public StandaloneAnalyser(IProgressMonitor pm, ILogger logger, PathTransformer pathTransformer, IPathCache pathCache, bool addAssemblyTrapPrefix)
            : base(pm, logger, pathTransformer, pathCache, addAssemblyTrapPrefix)
        {
        }

        public void Initialize(string outputPath, IEnumerable<(string, string)> compilationInfos, CSharpCompilation compilationIn, CommonOptions options)
        {
            compilation = compilationIn;
            ExtractionContext = new ExtractionContext(Directory.GetCurrentDirectory(), [], outputPath, compilationInfos, Logger, PathTransformer, ExtractorMode.Standalone, options.QlTest);
            this.options = options;
            LogExtractorInfo();
            SetReferencePaths();
        }
    }
}
