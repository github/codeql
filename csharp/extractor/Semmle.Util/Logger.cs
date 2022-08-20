using System;
using System.IO;

namespace Semmle.Util.Logging
{
    /// <summary>
    /// The severity of a log message.
    /// </summary>
    public enum Severity
    {
        Trace = 1,
        Debug = 2,
        Info = 3,
        Warning = 4,
        Error = 5
    }

    /// <summary>
    /// Log verbosity level.
    /// </summary>
    public enum Verbosity
    {
        Off = 0,
        Error = 1,
        Warning = 2,
        Info = 3,
        Debug = 4,
        Trace = 5,
        All = 6
    }

    /// <summary>
    /// A logger.
    /// </summary>
    public interface ILogger : IDisposable
    {
        /// <summary>
        /// Log the given text with the given severity.
        /// </summary>
        void Log(Severity s, string text);
    }

    public static class LoggerExtensions
    {
        /// <summary>
        /// Log the given text with the given severity.
        /// </summary>
        public static void Log(this ILogger logger, Severity s, string text, params object?[] args)
        {
            logger.Log(s, string.Format(text, args));
        }
    }

    /// <summary>
    /// A logger that outputs to a <code>csharp.log</code>
    /// file.
    /// </summary>
    public sealed class FileLogger : ILogger
    {
        private readonly StreamWriter writer;
        private readonly Verbosity verbosity;

        public FileLogger(Verbosity verbosity, string outputFile)
        {
            this.verbosity = verbosity;

            try
            {
                var dir = Path.GetDirectoryName(outputFile);
                if (!string.IsNullOrEmpty(dir) && !System.IO.Directory.Exists(dir))
                    Directory.CreateDirectory(dir);
                writer = new PidStreamWriter(
                    new FileStream(outputFile, FileMode.Append, FileAccess.Write, FileShare.ReadWrite, 8192));
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Console.Error.WriteLine("CodeQL: Couldn't initialise C# extractor output: " + ex.Message + "\n" + ex.StackTrace);
                Console.Error.Flush();
                throw;
            }
        }

        public void Dispose()
        {
            writer.Dispose();
        }

        private static string GetSeverityPrefix(Severity s)
        {
            return "[" + s.ToString().ToUpper() + "] ";
        }

        public void Log(Severity s, string text)
        {
            if (verbosity.Includes(s))
                writer.WriteLine(GetSeverityPrefix(s) + text);
        }
    }

    /// <summary>
    /// A logger that outputs to stdout/stderr.
    /// </summary>
    public sealed class ConsoleLogger : ILogger
    {
        private readonly Verbosity verbosity;

        public ConsoleLogger(Verbosity verbosity)
        {
            this.verbosity = verbosity;
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

        public void Log(Severity s, string text)
        {
            if (verbosity.Includes(s))
                GetConsole(s).WriteLine(GetSeverityPrefix(s) + text);
        }
    }

    /// <summary>
    /// A combined logger.
    /// </summary>
    public sealed class CombinedLogger : ILogger
    {
        private readonly ILogger logger1;
        private readonly ILogger logger2;

        public CombinedLogger(ILogger logger1, ILogger logger2)
        {
            this.logger1 = logger1;
            this.logger2 = logger2;
        }

        public void Dispose()
        {
            logger1.Dispose();
            logger2.Dispose();
        }

        public void Log(Severity s, string text)
        {
            logger1.Log(s, text);
            logger2.Log(s, text);
        }
    }

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
