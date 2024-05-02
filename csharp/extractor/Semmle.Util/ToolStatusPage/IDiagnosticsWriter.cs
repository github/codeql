using System;

namespace Semmle.Util
{
    /// <summary>
    /// Provides the ability to write diagnostic messages to some output.
    /// </summary>
    public interface IDiagnosticsWriter : IDisposable
    {
        /// <summary>
        /// Adds <paramref name="message" /> as a new diagnostics entry.
        /// </summary>
        /// <param name="message">The diagnostics entry to add.</param>
        void AddEntry(DiagnosticMessage message);
    }
}
