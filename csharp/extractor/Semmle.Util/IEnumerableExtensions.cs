using System;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Util
{
    public static class IEnumerableExtensions
    {
        /// <summary>
        /// Find the first element in the sequence, or null if the sequence is empty.
        /// </summary>
        /// <typeparam name="T">The type of the sequence.</typeparam>
        /// <param name="list">The list of items.</param>
        /// <returns>The first item, or null if the sequence is empty.</returns>
        public static T? FirstOrNull<T>(this IEnumerable<T> list) where T : struct
        {
            return list.Any() ? (T?)list.First() : null;
        }

        /// <summary>
        /// Finds the last element a sequence, or null if the sequence is empty.
        /// </summary>
        /// <typeparam name="T">The type of the elements in the sequence.</typeparam>
        /// <param name="list">The list of items.</param>
        /// <returns>The last item, or null if the sequence is empty.</returns>
        public static T? LastOrNull<T>(this IEnumerable<T> list) where T : struct
        {
            return list.Any() ? (T?)list.Last() : null;
        }

        /// <summary>
        /// Interleaves the elements from the two sequences.
        /// </summary>
        public static IEnumerable<T> Interleave<T>(this IEnumerable<T> first, IEnumerable<T> second)
        {
            using var enumerator1 = first.GetEnumerator();
            using var enumerator2 = second.GetEnumerator();
            bool moveNext1;
            while ((moveNext1 = enumerator1.MoveNext()) && enumerator2.MoveNext())
            {
                yield return enumerator1.Current;
                yield return enumerator2.Current;
            }

            if (moveNext1)
            {
                // `first` has more elements than `second`
                yield return enumerator1.Current;
                while (enumerator1.MoveNext())
                {
                    yield return enumerator1.Current;
                }
            }

            while (enumerator2.MoveNext())
            {
                // `second` has more elements than `first`
                yield return enumerator2.Current;
            }
        }

        /// <summary>
        /// Enumerates a possibly null enumerable.
        /// If the enumerable is null, the list is empty.
        /// </summary>
        public static IEnumerable<T> EnumerateNull<T>(this IEnumerable<T>? items)
        {
            if (items is null)
                yield break;
            foreach (var item in items) yield return item;
        }

        /// <summary>
        /// Applies the action <paramref name="a"/> to each item in this collection.
        /// </summary>
        public static void ForEach<T>(this IEnumerable<T> items, Action<T> a)
        {
            foreach (var item in items)
                a(item);
        }

        /// <summary>
        /// Forces enumeration of this collection and discards the result.
        /// </summary>
        public static void Enumerate<T>(this IEnumerable<T> items)
        {
            items.ForEach(_ => { });
        }

        /// <summary>
        /// Computes a hash of a sequence.
        /// </summary>
        /// <typeparam name="T">The type of the item.</typeparam>
        /// <param name="items">The list of items to hash.</param>
        /// <returns>The hash code.</returns>
        public static int SequenceHash<T>(this IEnumerable<T> items) where T : notnull
        {
            var h = 0;
            foreach (var i in items)
                h = h * 7 + i.GetHashCode();
            return h;
        }
    }
}
