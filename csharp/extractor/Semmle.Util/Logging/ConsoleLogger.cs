using System;
using System.IO;

namespace Semmle.Util.Logging
{
    /// <summary>
    /// A logger that outputs to stdout/stderr.
    /// </summary>
    public sealed class ConsoleLogger : ILogger
    {
        private readonly Verbosity verbosity;
        private readonly bool logThreadId;

        public ConsoleLogger(Verbosity verbosity, bool logThreadId)
        {
            this.verbosity = verbosity;
            this.logThreadId = logThreadId;
        }

        public void Dispose() { }

        private static TextWriter GetConsole(Severity s)
        {
            return s == Severity.Error ? Console.Error : Console.Out;
        }

        private static string GetSeverityPrefix(Severity s)
        {
            switch (s)
            {
                case Severity.Trace:
                case Severity.Debug:
                case Severity.Info:
                    return "";
                case Severity.Warning:
                    return "Warning: ";
                case Severity.Error:
                    return "Error: ";
                default:
                    throw new ArgumentOutOfRangeException(nameof(s));
            }
        }

        public void Log(Severity s, string text, int? threadId = null)
        {
            if (verbosity.Includes(s))
            {
                threadId ??= Environment.CurrentManagedThreadId;

                var prefix = this.logThreadId ? $"[{threadId:D3}] " : "";
                GetConsole(s).WriteLine(prefix + GetSeverityPrefix(s) + text);
            }
        }
    }
}
