namespace Semmle.Extraction.CSharp.Entities
{
    public abstract class CachedEntity<T> : Extraction.CachedEntity<T> where T : notnull
    {
        public override Context Context => (Context)base.Context;

        protected CachedEntity(Context context, T symbol)
            : base(context, symbol)
        {
        }
    }
}
