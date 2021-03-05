using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    public class TracingExtractor : Extractor
    {
        public override bool Standalone => false;

        public string OutputPath { get; }

        /// <summary>
        /// Creates a new extractor instance for one compilation unit.
        /// </summary>
        /// <param name="outputPath">The name of the output DLL/EXE, or null if not specified (standalone extraction).</param>
        /// <param name="logger">The object used for logging.</param>
        /// <param name="pathTransformer">The object used for path transformations.</param>
        public TracingExtractor(string outputPath, ILogger logger, PathTransformer pathTransformer) : base(logger, pathTransformer)
        {
            OutputPath = outputPath;
        }
    }
}
