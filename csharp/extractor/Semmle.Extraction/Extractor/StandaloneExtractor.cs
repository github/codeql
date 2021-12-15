using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    public class StandaloneExtractor : Extractor
    {
        public override bool Standalone => true;

        /// <summary>
        /// Creates a new extractor instance for one compilation unit.
        /// </summary>
        /// <param name="logger">The object used for logging.</param>
        /// <param name="pathTransformer">The object used for path transformations.</param>
        public StandaloneExtractor(ILogger logger, PathTransformer pathTransformer) : base(logger, pathTransformer)
        {
        }
    }
}
