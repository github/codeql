using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction
{
    /// <summary>
    /// An abstract symbol, which encapsulates a data type (such as a C# symbol).
    /// </summary>
    /// <typeparam name="TSymbol">The type of the symbol.</typeparam>
    public abstract class CachedEntity<TSymbol> : ICachedEntity
    {
        protected CachedEntity(Context context, TSymbol init)
        {
            Context = context;
            symbol = init;
        }

        public Label Label { get; set; }

        public abstract Microsoft.CodeAnalysis.Location? ReportingLocation { get; }

        public override string ToString() => Label.ToString();

        public abstract void Populate(TextWriter trapFile);

        /// <summary>
        /// For debugging.
        /// </summary>
        public string DebugContents
        {
            get
            {
                using var trap = new StringWriter();
                Populate(trap);
                return trap.ToString();
            }
        }

        public Context Context
        {
            get;
        }

        public TSymbol symbol
        {
            get;
        }

        object? ICachedEntity.UnderlyingObject => symbol;

        public TSymbol UnderlyingObject => symbol;

        public abstract void WriteId(System.IO.TextWriter trapFile);

        public virtual void WriteQuotedId(TextWriter trapFile)
        {
            trapFile.Write("@\"");
            WriteId(trapFile);
            trapFile.Write('\"');
        }

        public abstract bool NeedsPopulation
        {
            get;
        }

        public override int GetHashCode() => symbol is null ? 0 : symbol.GetHashCode();

        public override bool Equals(object? obj)
        {
            var other = obj as CachedEntity<TSymbol>;
            return other?.GetType() == GetType() && Equals(other.symbol, symbol);
        }

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }
    }

    /// <summary>
    /// A class used to wrap an `ISymbol` object, which uses `SymbolEqualityComparer.Default`
    /// for comparison.
    /// </summary>
    public sealed class SymbolEqualityWrapper
    {
        public ISymbol Symbol { get; }

        public SymbolEqualityWrapper(ISymbol symbol) { Symbol = symbol; }

        public override bool Equals(object? other) =>
            other is SymbolEqualityWrapper sew && SymbolEqualityComparer.Default.Equals(Symbol, sew.Symbol);

        public override int GetHashCode() => 11 * Symbol.GetHashCode();
    }
}
