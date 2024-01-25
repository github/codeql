using System;

namespace Semmle.Util.Logging
{
    internal static class VerbosityExtensions
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
    }
}
