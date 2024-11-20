namespace Semmle.Extraction.CSharp.Entities
{
    public abstract class SourceLocation : Location
    {
        protected SourceLocation(Context cx, Microsoft.CodeAnalysis.Location? init) : base(cx, init)
        {
        }

        public override bool NeedsPopulation => true;
    }
}
