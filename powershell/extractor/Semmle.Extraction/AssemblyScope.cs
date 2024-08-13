using Microsoft.CodeAnalysis;

namespace Semmle.Extraction
{
    /// <summary>
    /// The scope of symbols in an assembly.
    /// </summary>
    public class AssemblyScope : IExtractionScope
    {
        private readonly IAssemblySymbol assembly;
        private readonly string filepath;

        public AssemblyScope(IAssemblySymbol symbol, string path)
        {
            assembly = symbol;
            filepath = path;
        }

        public bool InFileScope(string path) => path == filepath;

        public bool InScope(ISymbol symbol) =>
            SymbolEqualityComparer.Default.Equals(symbol.ContainingAssembly, assembly) ||
            SymbolEqualityComparer.Default.Equals(symbol, assembly);
    }
}
