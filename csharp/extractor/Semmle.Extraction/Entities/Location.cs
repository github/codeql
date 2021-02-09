namespace Semmle.Extraction.Entities
{
    public abstract class Location : CachedEntity<Microsoft.CodeAnalysis.Location?>
    {
        protected Location(Context cx, Microsoft.CodeAnalysis.Location? init)
            : base(cx, init) { }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => symbol;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
