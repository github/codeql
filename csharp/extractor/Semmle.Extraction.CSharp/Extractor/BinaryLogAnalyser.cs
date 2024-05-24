using Microsoft.CodeAnalysis.CSharp;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    public class BinaryLogAnalyser : Analyser
    {
        public BinaryLogAnalyser(IProgressMonitor pm, ILogger logger, bool addAssemblyTrapPrefix, PathTransformer pathTransformer)
            : base(pm, logger, addAssemblyTrapPrefix, pathTransformer)
        {
        }

        public void Initialize(string cwd, string[] args, string outputPath, CSharpCompilation compilationIn, CommonOptions options)
        {
            compilation = compilationIn;
            extractor = new BinaryLogExtractor(cwd, args, outputPath, Logger, PathTransformer, options);
            this.options = options;
            LogExtractorInfo(Extraction.Extractor.Version);
            SetReferencePaths();
        }
    }
}
