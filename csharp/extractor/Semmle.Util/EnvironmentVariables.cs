using System;

namespace Semmle.Util
{
    public class EnvironmentVariables
    {
        public static string? GetExtractorOption(string name) =>
            Environment.GetEnvironmentVariable($"CODEQL_EXTRACTOR_CSHARP_OPTION_{name.ToUpper()}");

        public static string? GetScratchDirectory() => Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_SCRATCH_DIR");

        public static int GetDefaultNumberOfThreads()
        {
            if (!int.TryParse(Environment.GetEnvironmentVariable("CODEQL_THREADS"), out var threads) || threads == -1)
            {
                threads = Environment.ProcessorCount;
            }
            return threads;
        }
    }
}
