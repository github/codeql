namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class CachedEntity<T> : Extraction.CachedEntity<T>
    {
        // todo: this can be changed to an override after the .NET 5 upgrade
        protected new Context Context => (Context)base.Context;

        protected CachedEntity(Context context, T symbol) : base(context, symbol)
        {
        }
    }
}
