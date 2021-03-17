namespace Semmle.Extraction.Entities
{
    public abstract class SourceLocation : Location
    {
        protected SourceLocation(Context cx, Microsoft.CodeAnalysis.Location? init) : base(cx, init)
        {
        }

        public override bool NeedsPopulation => true;
    }
}
