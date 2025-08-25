using System;
using System.Collections.Generic;
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

        public static bool GetBooleanOptOut(string name)
        {
            var env = Environment.GetEnvironmentVariable(name);
            if (env == null ||
                bool.TryParse(env, out var value) &&
                value)
            {
                return true;
            }

            return false;
        }

        public static bool GetBoolean(string name)
        {
            var env = Environment.GetEnvironmentVariable(name);
            _ = bool.TryParse(env, out var value);
            return value;
        }

        public static IEnumerable<string> GetURLs(string name)
        {
            return Environment.GetEnvironmentVariable(name)?.Split(" ", StringSplitOptions.RemoveEmptyEntries) ?? [];
        }
    }
}
