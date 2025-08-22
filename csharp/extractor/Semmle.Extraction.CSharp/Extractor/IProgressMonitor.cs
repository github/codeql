using System;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Callback for various extraction events.
    /// (Used for display of progress).
    /// </summary>
    public interface IProgressMonitor
    {
        /// <summary>
        /// Callback that a particular item has been analysed.
        /// </summary>
        /// <param name="item">The item number being processed.</param>
        /// <param name="total">The total number of items to process.</param>
        /// <param name="source">The name of the item, e.g. a source file.</param>
        /// <param name="output">The name of the item being output, e.g. a trap file.</param>
        /// <param name="time">The time to extract the item.</param>
        /// <param name="action">What action was taken for the file.</param>
        void Analysed(int item, int total, string source, string output, TimeSpan time, AnalysisAction action);

        /// <summary>
        /// Callback that processing of a particular item has been started.
        /// </summary>
        void Started(int item, int total, string source);

        /// <summary>
        /// A "using namespace" directive was seen but the given
        /// namespace could not be found.
        /// Only called once for each @namespace.
        /// </summary>
        /// <param name="namespace"></param>
        void MissingNamespace(string @namespace);

        /// <summary>
        /// An ErrorType was found.
        /// Called once for each type name.
        /// </summary>
        /// <param name="type">The full/partial name of the type.</param>
        void MissingType(string type);

        /// <summary>
        /// Report a summary of missing entities.
        /// </summary>
        /// <param name="types">The number of missing types.</param>
        /// <param name="namespaces">The number of missing using namespace declarations.</param>
        void MissingSummary(int types, int namespaces);
    }
}
