namespace Semmle.Extraction.CSharp.Entities
{
#nullable disable warnings
    public abstract class Location : CachedEntity<Microsoft.CodeAnalysis.Location?>
    {
#nullable restore warnings
        protected Location(Context cx, Microsoft.CodeAnalysis.Location? init)
            : base(cx, init)
        { }

        protected static void WriteStarId(EscapingTextWriter writer)
        {
            writer.Write('*');
        }

        public sealed override void WriteQuotedId(EscapingTextWriter writer)
        {
            if (Context.ExtractionContext.IsStandalone)
            {
                WriteStarId(writer);
                return;
            }

            base.WriteQuotedId(writer);
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => Symbol;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
