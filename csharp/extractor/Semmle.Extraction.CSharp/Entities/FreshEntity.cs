namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class FreshEntity : Extraction.FreshEntity
    {
        // todo: this can be changed to an override after the .NET 5 upgrade
        protected new Context Context => (Context)base.Context;

        protected FreshEntity(Context cx)
            : base(cx)
        {
        }
    }
}
