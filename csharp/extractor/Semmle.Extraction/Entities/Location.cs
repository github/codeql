
namespace Semmle.Extraction.Entities
{
    public abstract class Location : CachedEntity<Microsoft.CodeAnalysis.Location?>
    {
        protected Location(Context cx, Microsoft.CodeAnalysis.Location? init)
            : base(cx, init) { }

        public static Location Create(Context cx, Microsoft.CodeAnalysis.Location? loc) =>
            (loc == null || loc.Kind == Microsoft.CodeAnalysis.LocationKind.None)
                ? GeneratedLocation.Create(cx)
                : loc.IsInSource
                    ? NonGeneratedSourceLocation.Create(cx, loc)
                    : Assembly.Create(cx, loc);

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => symbol;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }

    public static class LocationExtensions
    {
        /// <summary>
        /// Creates a Location entity.
        /// </summary>
        /// <param name="cx">The extraction context.</param>
        /// <param name="location">The CodeAnalysis location.</param>
        /// <returns>The Location entity.</returns>
        public static Location Create(this Context cx, Microsoft.CodeAnalysis.Location? location) =>
            Location.Create(cx, location);
    }
}
