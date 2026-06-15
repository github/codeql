using System;
using System.IO;

namespace Semmle.Util.Logging
{
    /// <summary>
    /// A logger that outputs to a <code>csharp.log</code>
    /// file.
    /// </summary>
    public sealed class FileLogger : ILogger
    {
        private readonly StreamWriter writer;
        private readonly Verbosity verbosity;
        private readonly bool logThreadId;

        public FileLogger(Verbosity verbosity, string outputFile, bool logThreadId)
        {
            this.verbosity = verbosity;
            this.logThreadId = logThreadId;

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
                Console.Error.WriteLine($"CodeQL: Couldn't initialise C# extractor output: {ex.Message}\n{ex.StackTrace}");
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
            return $"[{s.ToString().ToUpper()}] ";
        }

        public void Log(Severity s, string text, int? threadId = null)
        {
            if (verbosity.Includes(s))
            {
                threadId ??= Environment.CurrentManagedThreadId;

                var prefix = this.logThreadId ? $"[{threadId:D3}] " : "";
                writer.WriteLine(prefix + GetSeverityPrefix(s) + text);
            }
        }
    }
}
