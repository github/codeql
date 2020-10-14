using Microsoft.CodeAnalysis;
using System.Linq;

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

        bool IsGlobalScope { get; }

        bool FromSource { get; }
    }

    /// <summary>
    /// The scope of symbols in an assembly.
    /// </summary>
    public class AssemblyScope : IExtractionScope
    {
        private readonly IAssemblySymbol assembly;
        private readonly string filepath;

        public AssemblyScope(IAssemblySymbol symbol, string path, bool isOutput)
        {
            assembly = symbol;
            filepath = path;
            IsGlobalScope = isOutput;
        }

        public bool IsGlobalScope { get; }

        public bool InFileScope(string path) => path == filepath;

        public bool InScope(ISymbol symbol) =>
            SymbolEqualityComparer.Default.Equals(symbol.ContainingAssembly, assembly) ||
            SymbolEqualityComparer.Default.Equals(symbol, assembly);

        public bool FromSource => false;
    }

    /// <summary>
    /// The scope of symbols in a source file.
    /// </summary>
    public class SourceScope : IExtractionScope
    {
        private readonly SyntaxTree sourceTree;

        public SourceScope(SyntaxTree tree)
        {
            sourceTree = tree;
        }

        public bool IsGlobalScope => false;

        public bool InFileScope(string path) => path == sourceTree.FilePath;

        public bool InScope(ISymbol symbol) => symbol.Locations.Any(loc => loc.SourceTree == sourceTree);

        public bool FromSource => true;
    }
}
