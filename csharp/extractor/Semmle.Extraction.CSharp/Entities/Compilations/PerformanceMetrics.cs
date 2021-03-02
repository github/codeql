using System.Collections.Generic;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// The various performance metrics to log.
    /// </summary>
    public struct PerformanceMetrics
    {
        public Timings Frontend { get; set; }
        public Timings Extractor { get; set; }
        public Timings Total { get; set; }
        public long PeakWorkingSet { get; set; }

        /// <summary>
        /// These are in database order (0 indexed)
        /// </summary>
        public IEnumerable<float> Metrics
        {
            get
            {
                yield return (float)Frontend.Cpu.TotalSeconds;
                yield return (float)Frontend.Elapsed.TotalSeconds;
                yield return (float)Extractor.Cpu.TotalSeconds;
                yield return (float)Extractor.Elapsed.TotalSeconds;
                yield return (float)Frontend.User.TotalSeconds;
                yield return (float)Extractor.User.TotalSeconds;
                yield return PeakWorkingSet / 1024.0f / 1024.0f;
            }
        }
    }
}
