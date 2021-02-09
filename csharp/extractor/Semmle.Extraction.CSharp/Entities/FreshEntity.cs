namespace Semmle.Extraction.CSharp.Entities
{
    public abstract class FreshEntity : Extraction.FreshEntity
    {
        protected override Context cx => (Context)base.cx;

        protected FreshEntity(Context cx) : base(cx)
        {
        }
    }
}
