
using Microsoft.CodeAnalysis.Text;

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

        public static Location Create(Context cx)
        {
            return cx.SourceTree == null
                ? GeneratedLocation.Create(cx)
                : Create(cx, Microsoft.CodeAnalysis.Location.Create(cx.SourceTree, TextSpan.FromBounds(0, 0)));
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => symbol;
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
