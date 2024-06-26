using System;
using System.Collections.Generic;
using System.Linq;
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

        private static int GetLocationKindPriority(Location location) =>
            location.IsInSource
                ? 2
                : location.IsInMetadata
                    ? 1
                    : 0;

        /// <summary>
        /// Returns true if l1 is better than l2.
        /// Source locations are considered better than non source locations.
        /// </summary>
        private static bool BetterThan(Location l1, Location l2)
        {
            if (GetLocationKindPriority(l1) > GetLocationKindPriority(l2))
            {
                return true;
            }

            // For source locations we compare the filepath and span.
            if (l1.IsInSource && l2.IsInSource)
            {
                var l1s = l1.SourceTree.FilePath + l1.SourceSpan;
                var l2s = l2.SourceTree.FilePath + l2.SourceSpan;
                return l1s.CompareTo(l2s) < 0;
            }

            return false;
        }

        /// <summary>
        /// Returns the best location from the given list of locations.
        /// Source locations are considered better than non-source locations.
        /// In case of a (source location) tie, the location with the
        /// lexicographically smaller filepath and span is considered better.
        /// </summary>
        public static Location? BestOrDefault(this IEnumerable<Location> locations) =>
            locations.Any() ? locations.Aggregate((best, loc) => BetterThan(loc, best) ? loc : best) : null;

        public static Location Best(this IEnumerable<Location> locations) =>
            locations.BestOrDefault() ?? throw new ArgumentException("No location found.");
    }
}
