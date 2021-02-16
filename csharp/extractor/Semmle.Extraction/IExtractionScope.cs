using Microsoft.CodeAnalysis;

namespace Semmle.Extraction
{
    /// <summary>
    /// Defines which entities belong in the trap file
    /// for the currently extracted entity. This is used to ensure that
    /// trap files do not contain redundant information. Generally a symbol
    /// should have an affinity with exactly one trap file, except for constructed
    /// symbols.
    /// </summary>
    public interface IExtractionScope
    {
        /// <summary>
        /// Whether the given symbol belongs in the trap file.
        /// </summary>
        /// <param name="symbol">The symbol to populate.</param>
        bool InScope(ISymbol symbol);

        /// <summary>
        /// Whether the given file belongs in the trap file.
        /// </summary>
        /// <param name="path">The path to populate.</param>
        bool InFileScope(string path);
    }
}
