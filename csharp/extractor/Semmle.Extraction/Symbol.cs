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

        public abstract Microsoft.CodeAnalysis.Location ReportingLocation { get; }

        public override string ToString() => Label.ToString();

        public abstract void Populate();

        public Context Context
        {
            get; private set;
        }

        public Initializer symbol
        {
            get; private set;
        }

        object ICachedEntity.UnderlyingObject => symbol;

        public Initializer UnderlyingObject => symbol;

        public abstract IId Id
        {
            get;
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

        public override int GetHashCode() => symbol.GetHashCode();

        public override bool Equals(object obj)
        {
            var other = obj as CachedEntity<Initializer>;
            return other?.GetType() == GetType() && Equals(other.symbol, symbol);
        }

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }
    }
}
