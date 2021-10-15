namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class FreshEntity : Extraction.FreshEntity
    {
        public override Context Context => (Context)base.Context;

        protected FreshEntity(Context cx)
            : base(cx)
        {
        }
    }
}
