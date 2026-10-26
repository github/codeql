namespace Semmle.Extraction.CSharp
{
    public abstract class UnlabelledEntity : Entity
    {
        protected UnlabelledEntity(Context cx) : base(cx)
        {
            cx.AddFreshLabel(this);
        }

        public sealed override void WriteId(EscapingTextWriter writer)
        {
            writer.Write('*');
        }

        public sealed override void WriteQuotedId(EscapingTextWriter writer)
        {
            writer.Write('*');
        }
    }
}
