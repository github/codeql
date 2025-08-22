using System.Diagnostics.CodeAnalysis;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// A cached entity.
    ///
    /// The <see cref="Entity.Label"/> property is used as label in caching.
    /// </summary>
    public abstract class CachedEntity : LabelledEntity
    {
        protected CachedEntity(Context context) : base(context)
        {
        }

        /// <summary>
        /// Populates the <see cref="Label"/> field and generates output in the trap file
        /// as required. Is only called when <see cref="NeedsPopulation"/> returns
        /// <code>true</code> and the entity has not already been populated.
        /// </summary>
        public abstract void Populate(TextWriter trapFile);

        public abstract bool NeedsPopulation { get; }
    }

    /// <summary>
    /// An abstract symbol, which encapsulates a data type (such as a C# symbol).
    /// </summary>
    /// <typeparam name="TSymbol">The type of the symbol.</typeparam>
    public abstract class CachedEntity<TSymbol> : CachedEntity where TSymbol : notnull
    {
        [NotNull]
        public TSymbol Symbol { get; }

        protected CachedEntity(Context context, TSymbol symbol) : base(context)
        {
            this.Symbol = symbol;
        }

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

        public override bool NeedsPopulation { get; }

        public override int GetHashCode() => Symbol is null ? 0 : Symbol.GetHashCode();

        public override bool Equals(object? obj)
        {
            var other = obj as CachedEntity<TSymbol>;
            return other?.GetType() == GetType() && Equals(other.Symbol, Symbol);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }

    /// <summary>
    /// A class used to wrap an `ISymbol` object, which uses `SymbolEqualityComparer.Default`
    /// for comparison.
    /// </summary>
    public struct SymbolEqualityWrapper
    {
        public ISymbol Symbol { get; }

        public SymbolEqualityWrapper(ISymbol symbol) { Symbol = symbol; }

        public override bool Equals(object? other) =>
            other is SymbolEqualityWrapper sew && SymbolEqualityComparer.Default.Equals(Symbol, sew.Symbol);

        public override int GetHashCode() => 11 * SymbolEqualityComparer.Default.GetHashCode(Symbol);
    }
}
