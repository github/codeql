using Microsoft.CodeAnalysis;
using System.Linq;

namespace Semmle.Extraction
{

    /// <summary>
    /// The scope of symbols in a source file.
    /// </summary>
    public class SourceScope : IExtractionScope
    {
        public SyntaxTree SourceTree { get; }

        public SourceScope(SyntaxTree tree)
        {
            SourceTree = tree;
        }

        public bool InFileScope(string path) => path == SourceTree.FilePath;

        public bool InScope(ISymbol symbol) => symbol.Locations.Any(loc => loc.SourceTree == SourceTree);
    }
}
