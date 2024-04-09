using System;
using System.Globalization;
using System.Numerics;

namespace Semmle.Util
{
    public class EnvironmentVariables
    {
        public static string? GetExtractorOption(string name) =>
            Environment.GetEnvironmentVariable($"CODEQL_EXTRACTOR_CSHARP_OPTION_{name.ToUpper()}");

        public static T? TryGetExtractorNumberOption<T>(string name) where T : struct, INumberBase<T>
        {
            var value = GetExtractorOption(name);
            if (T.TryParse(value, NumberStyles.Number, CultureInfo.InvariantCulture, out var result))
            {
                return result;
            }
            return null;
        }

        public static int GetDefaultNumberOfThreads()
        {
            if (!int.TryParse(Environment.GetEnvironmentVariable("CODEQL_THREADS"), out var threads) || threads == -1)
            {
                threads = Environment.ProcessorCount;
            }
            return threads;
        }

        public static bool GetBoolean(string name)
        {
            var env = Environment.GetEnvironmentVariable(name);
            var _ = bool.TryParse(env, out var value);
            return value;
        }
    }
}
