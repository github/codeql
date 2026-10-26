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

        /// <summary>
        /// Used to
        /// (1) Detect whether the extractor should run in overlay mode.
        /// (2) Returns the path to the file containing a list of changed files
        /// in JSON format.
        ///
        /// The environment variable is only set in case the extraction is supposed to be
        /// performed in overlay mode. Furthermore, this only applies to buildless extraction.
        /// </summary>
        public static string? GetOverlayChangesFilePath()
        {
            return Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_OVERLAY_CHANGES");
        }

        /// <summary>
        /// If the environment variable is set, the extractor is being called to extract a base database.
        /// Its value will be a path, and the extractor must create either a file or directory at that location.
        /// </summary>
        public static string? GetBaseMetaDataOutPath()
        {
            return Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_OVERLAY_BASE_METADATA_OUT");
        }

        /// <summary>
        /// If set, returns the directory where buildless dependencies should be stored.
        /// This can be used for caching dependencies.
        /// </summary>
        public static string? GetBuildlessDependencyDir()
        {
            return Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_OPTION_BUILDLESS_DEPENDENCY_DIR");
        }
    }
}
