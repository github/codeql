using System.Collections.Generic;
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

        public void Initialize(
            string cwd, string[] args, string outputPath, CSharpCompilation compilation,
            IEnumerable<Microsoft.CodeAnalysis.SyntaxTree> generatedSyntaxTrees,
            string compilationIdentifier, CommonOptions options)
        {
            base.compilation = compilation;
            ExtractionContext = new BinaryLogExtractionContext(
                cwd, args, outputPath, generatedSyntaxTrees, compilationIdentifier,
                Logger, PathTransformer, options.QlTest);
            this.options = options;
            LogExtractorInfo();
            SetReferencePaths();
        }
    }
}
