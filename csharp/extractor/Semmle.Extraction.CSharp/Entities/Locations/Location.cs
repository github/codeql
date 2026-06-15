namespace Semmle.Extraction.CSharp.Entities
{
#nullable disable warnings
    public abstract class Location : CachedEntity<Microsoft.CodeAnalysis.Location?>
    {
#nullable restore warnings
        protected Location(Context cx, Microsoft.CodeAnalysis.Location? init)
            : base(cx, init) { }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => Symbol;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
