using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    public class StandaloneExtractor : Extractor
    {
        private readonly ExtractorMode mode;
        public override ExtractorMode Mode => mode;

        /// <summary>
        /// Creates a new extractor instance for one compilation unit.
        /// </summary>
        /// <param name="logger">The object used for logging.</param>
        /// <param name="pathTransformer">The object used for path transformations.</param>
        public StandaloneExtractor(ILogger logger, PathTransformer pathTransformer, CommonOptions options) : base(logger, pathTransformer)
        {
            mode = ExtractorMode.Standalone;
            if (options.QlTest)
                mode |= ExtractorMode.QlTest;
        }
    }
}
