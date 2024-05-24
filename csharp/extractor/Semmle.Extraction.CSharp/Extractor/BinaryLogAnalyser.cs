using Microsoft.CodeAnalysis.CSharp;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    public class BinaryLogAnalyser : Analyser
    {
        public BinaryLogAnalyser(IProgressMonitor pm, ILogger logger, PathTransformer pathTransformer, IPathCache pathCache, bool addAssemblyTrapPrefix)
            : base(pm, logger, pathTransformer, pathCache, addAssemblyTrapPrefix)
        {
        }

        public void Initialize(string cwd, string[] args, string outputPath, CSharpCompilation compilationIn, CommonOptions options)
        {
            compilation = compilationIn;
            ExtractionContext = new ExtractionContext(cwd, args, outputPath, [], Logger, PathTransformer, ExtractorMode.BinaryLog, options.QlTest);
            this.options = options;
            LogExtractorInfo();
            SetReferencePaths();
        }
    }
}
