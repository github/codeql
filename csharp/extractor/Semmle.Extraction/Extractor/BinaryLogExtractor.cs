using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    public class BinaryLogExtractor : Extractor
    {
        public override ExtractorMode Mode { get; }

        public BinaryLogExtractor(string cwd, string[] args, string outputPath, ILogger logger, PathTransformer pathTransformer, CommonOptions options)
            : base(cwd, args, outputPath, [], logger, pathTransformer)
        {
            Mode = ExtractorMode.BinaryLog;
            if (options.QlTest)
            {
                Mode |= ExtractorMode.QlTest;
            }
        }
    }
}
