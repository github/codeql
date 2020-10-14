using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Semmle.Util
{
    /// <summary>
    /// A dictionary from strings to elements of type T.
    /// </summary>
    ///
    /// <remarks>
    /// This data structure is able to locate items based on an "approximate match"
    /// of the key. This is used for example when attempting to identify two terms
    /// in different trap files which are similar but not identical.
    ///
    /// The algorithm locates the closest match to a string based on a "distance function".
    ///
    /// Whilst many distance functions are possible, a bespoke algorithm is used here,
    /// for efficiency and suitablility for the domain.
    ///
    /// The distance is defined as the Hamming Distance of the numbers in the string.
    /// Each string is split into the base "form" (stripped of numbers) and a vector of
    /// numbers. (Numbers are non-negative integers in this context).
    ///
    /// Strings with a different "form" are considered different and have a distance
    /// of infinity.
    ///
    /// This distance function is reflexive, symmetric and obeys the triangle inequality.
    ///
    /// E.g. foo(bar,1,2) has form "foo(bar,,)" and integers {1,2}
    ///
    /// distance(foo(bar,1,2), foo(bar,1,2)) = 0
    /// distance(foo(bar,1,2), foo(bar,1,3)) = 1
    /// distance(foo(bar,2,1), foo(bar,1,2)) = 2
    /// distance(foo(bar,1,2), foo(baz,1,2)) = infinity
    /// </remarks>
    ///
    /// <typeparam name="T">The value type.</typeparam>
    public class FuzzyDictionary<T> where T : class
    {
        // All data items indexed by the "base string" (stripped of numbers)
        private readonly Dictionary<string, List<KeyValuePair<string, T>>> index = new Dictionary<string, List<KeyValuePair<string, T>>>();

        /// <summary>
        /// Stores a new KeyValuePair in the data structure.
        /// </summary>
        /// <param name="k">The key.</param>
        /// <param name="v">The value.</param>
        public void Add(string k, T v)
        {
            var kv = new KeyValuePair<string, T>(k, v);

            var root = StripDigits(k);
            index.AddAnother(root, kv);
        }

        /// <summary>
        /// Computes the Hamming Distance between two sequences of the same length.
        /// </summary>
        /// <param name="v1">Vector 1</param>
        /// <param name="v2">Vector 2</param>
        /// <returns>The Hamming Distance.</returns>
        private static int HammingDistance<TElement>(IEnumerable<TElement> v1, IEnumerable<TElement> v2) where TElement : notnull
        {
            return v1.Zip(v2, (x, y) => x.Equals(y) ? 0 : 1).Sum();
        }

        /// <summary>
        /// Locates the value with the smallest Hamming Distance from the query.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <param name="distance">The distance between the query string and the stored string.</param>
        /// <returns>The best match, or null (default).</returns>
        public T? FindMatch(string query, out int distance)
        {
            var root = StripDigits(query);
            if (!index.TryGetValue(root, out var list))
            {
                distance = 0;
                return default(T);
            }

            return BestMatch(query, list, (a, b) => HammingDistance(ExtractIntegers(a), ExtractIntegers(b)), out distance);
        }

        /// <summary>
        /// Returns the best match (with the smallest distance) for a query.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <param name="candidates">The list of candidate matches.</param>
        /// <param name="distance">The distance function.</param>
        /// <param name="bestDistance">The distance between the query and the stored string.</param>
        /// <returns>The stored value.</returns>
        private static T? BestMatch(string query, IEnumerable<KeyValuePair<string, T>> candidates, Func<string, string, int> distance, out int bestDistance)
        {
            var bestMatch = default(T);
            bestDistance = 0;
            var first = true;

            foreach (var candidate in candidates)
            {
                var d = distance(query, candidate.Key);
                if (d == 0)
                    return candidate.Value;

                if (first || d < bestDistance)
                {
                    bestDistance = d;
                    bestMatch = candidate.Value;
                    first = false;
                }
            }

            return bestMatch;
        }

        /// <summary>
        /// Removes all digits from a string.
        /// </summary>
        /// <param name="input">The input string.</param>
        /// <returns>String with digits removed.</returns>
        private static string StripDigits(string input)
        {
            var result = new StringBuilder();
            foreach (var c in input.Where(c => !char.IsDigit(c)))
                result.Append(c);
            return result.ToString();
        }

        /// <summary>
        /// Extracts and enumerates all non-negative integers in a string.
        /// </summary>
        /// <param name="input">The string to enumerate.</param>
        /// <returns>The sequence of integers.</returns>
        private static IEnumerable<int> ExtractIntegers(string input)
        {
            var inNumber = false;
            var value = 0;
            foreach (var c in input)
            {
                if (char.IsDigit(c))
                {
                    if (inNumber)
                    {
                        value = value * 10 + (c - '0');
                    }
                    else
                    {
                        inNumber = true;
                        value = c - '0';
                    }
                }
                else
                {
                    if (inNumber)
                    {
                        yield return value;
                        inNumber = false;
                    }
                }
            }
        }
    }
}
