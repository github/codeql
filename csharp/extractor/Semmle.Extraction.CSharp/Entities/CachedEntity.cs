namespace Semmle.Extraction.CSharp.Entities
{
    public abstract class CachedEntity<TSymbol> : Extraction.CachedEntity<TSymbol>
    {
        public override Context Context => (Context)base.Context;

        protected CachedEntity(Context context, TSymbol init) : base(context, init)
        {
        }
    }
}
