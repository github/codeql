using System;

namespace Semmle.Extraction.PowerShell
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
    }
}
