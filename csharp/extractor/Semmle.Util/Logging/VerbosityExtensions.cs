using System;

namespace Semmle.Util.Logging
{
    public static class VerbosityExtensions
    {
        /// <summary>
        /// Whether a message with the given severity must be included
        /// for this verbosity level.
        /// </summary>
        public static bool Includes(this Verbosity v, Severity s)
        {
            switch (s)
            {
                case Severity.Trace:
                    return v >= Verbosity.Trace;
                case Severity.Debug:
                    return v >= Verbosity.Debug;
                case Severity.Info:
                    return v >= Verbosity.Info;
                case Severity.Warning:
                    return v >= Verbosity.Warning;
                case Severity.Error:
                    return v >= Verbosity.Error;
                default:
                    throw new ArgumentOutOfRangeException(nameof(s));
            }
        }

        public static Verbosity? ParseVerbosity(string? str, bool logThreadId)
        {
            if (str == null)
            {
                return null;
            }

            Verbosity? verbosity = str.ToLowerInvariant() switch
            {
                "off" => Verbosity.Off,
                "errors" => Verbosity.Error,
                "warnings" => Verbosity.Warning,
                "info" or "progress" => Verbosity.Info,
                "debug" or "progress+" => Verbosity.Debug,
                "trace" or "progress++" => Verbosity.Trace,
                "progress+++" => Verbosity.All,
                _ => null
            };

            if (verbosity == null && str != null)
            {
                // We don't have a logger when this setting is parsed, so writing it to the console:
                var prefix = logThreadId ? $"[{Environment.CurrentManagedThreadId:D3}] " : "";
                Console.WriteLine($"{prefix}Error: Invalid verbosity level: '{str}'");
            }

            return verbosity;
        }
    }
}
