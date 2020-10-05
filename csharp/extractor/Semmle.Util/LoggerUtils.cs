using System;
using System.IO;
using System.Diagnostics;

namespace Semmle.Util
{
    /// <summary>
    /// Utility stream writer that prefixes the current PID to some writes.
    /// Useful to disambiguate logs belonging to different extractor processes
    /// that end up in the same place (csharp.log). Does a best-effort attempt
    /// (i.e. only overrides one of the overloaded methods, calling the others
    /// may print without a prefix).
    /// </summary>
    public sealed class PidStreamWriter : StreamWriter
    {
        /// <summary>
        /// Constructs with output stream.
        /// </summary>
        /// <param name="stream">The stream to write to.</param>
        public PidStreamWriter(Stream stream) : base(stream) { }

        private readonly string prefix = "[" + Process.GetCurrentProcess().Id + "] ";

        public override void WriteLine(string? value)
        {
            lock (mutex)
            {
                base.WriteLine(prefix + value);
            }
        }

        public override void WriteLine(string? format, params object?[] args)
        {
            WriteLine(format is null ? format : string.Format(format, args));
        }

        private readonly object mutex = new object();
    }
}
