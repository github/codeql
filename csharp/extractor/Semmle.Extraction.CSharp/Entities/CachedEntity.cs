namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class CachedEntity<T> : Extraction.CachedEntity<T> where T : notnull
    {
        public override Context Context => (Context)base.Context;

        protected CachedEntity(Context context, T symbol)
            : base(context, symbol)
        {
        }
    }
}
