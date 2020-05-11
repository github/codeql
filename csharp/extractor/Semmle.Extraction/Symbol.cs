using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// An abstract symbol, which encapsulates a data type (such as a C# symbol).
    /// </summary>
    /// <typeparam name="Initializer">The type of the symbol.</typeparam>
    public abstract class CachedEntity<Initializer> : ICachedEntity
    {
        public CachedEntity(Context context, Initializer init)
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
                using (var trap = new StringWriter())
                {
                    Populate(trap);
                    return trap.ToString();
                }
            }
        }

        public Context Context
        {
            get;
        }

        public Initializer symbol
        {
            get;
        }

        object? ICachedEntity.UnderlyingObject => symbol;

        public Initializer UnderlyingObject => symbol;

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

        /// <summary>
        /// Runs the given action <paramref name="a"/>, guarding for trap duplication
        /// based on the ID an location of this entity.
        /// </summary>
        protected void WithDuplicationGuard(System.Action a, IEntity location)
        {
            var key = new Key(this, location);
            Context.WithDuplicationGuard(key, a);
        }

        public override int GetHashCode() => symbol is null ? 0 : symbol.GetHashCode();

        public override bool Equals(object? obj)
        {
            var other = obj as CachedEntity<Initializer>;
            return other?.GetType() == GetType() && Equals(other.symbol, symbol);
        }

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }
    }
}
