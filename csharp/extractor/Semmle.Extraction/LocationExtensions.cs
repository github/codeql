using Microsoft.CodeAnalysis;

namespace Semmle.Extraction
{
    public static class LocationExtensions
    {
        public static int StartLine(this Location loc) => loc.GetLineSpan().Span.Start.Line;

        public static int StartColumn(this Location loc) => loc.GetLineSpan().Span.Start.Character;

        public static int EndLine(this Location loc) => loc.GetLineSpan().Span.End.Line;

        /// <summary>
        /// Whether one Location outer completely contains another Location inner.
        /// </summary>
        /// <param name="outer">The outer location.</param>
        /// <param name="inner">The inner location</param>
        /// <returns>Whether inner is completely container in outer.</returns>
        public static bool Contains(this Location outer, Location inner)
        {
            var sameFile = outer.SourceTree == inner.SourceTree;
            var startsBefore = outer.SourceSpan.Start <= inner.SourceSpan.Start;
            var endsAfter = outer.SourceSpan.End >= inner.SourceSpan.End;
            return sameFile && startsBefore && endsAfter;
        }

        /// <summary>
        /// Whether one Location ends before another starts.
        /// </summary>
        /// <param name="before">The Location coming before</param>
        /// <param name="after">The Location coming after</param>
        /// <returns>Whether 'before' comes before 'after'.</returns>
        public static bool Before(this Location before, Location after)
        {
            var sameFile = before.SourceTree == after.SourceTree;
            var endsBefore = before.SourceSpan.End <= after.SourceSpan.Start;
            return sameFile && endsBefore;
        }
    }
}
