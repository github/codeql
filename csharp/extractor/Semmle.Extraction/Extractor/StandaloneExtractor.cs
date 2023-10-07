using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    public class StandaloneExtractor : Extractor
    {
        public override ExtractorMode Mode { get; }

        /// <summary>
        /// Creates a new extractor instance for one compilation unit.
        /// </summary>
        /// <param name="logger">The object used for logging.</param>
        /// <param name="pathTransformer">The object used for path transformations.</param>
        public StandaloneExtractor(string outputPath, ILogger logger, PathTransformer pathTransformer, CommonOptions options) : base(outputPath, logger, pathTransformer)
        {
            Mode = ExtractorMode.Standalone;
            if (options.QlTest)
            {
                Mode |= ExtractorMode.QlTest;
            }
        }
    }
}
