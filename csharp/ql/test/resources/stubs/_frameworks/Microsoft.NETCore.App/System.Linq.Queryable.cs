// This file contains auto-generated code.

namespace System
{
    namespace Linq
    {
        // Generated from `System.Linq.EnumerableExecutor` in `System.Linq.Queryable, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EnumerableExecutor
        {
            internal EnumerableExecutor() => throw null;
        }

        // Generated from `System.Linq.EnumerableExecutor<>` in `System.Linq.Queryable, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EnumerableExecutor<T> : System.Linq.EnumerableExecutor
        {
            public EnumerableExecutor(System.Linq.Expressions.Expression expression) => throw null;
        }

        // Generated from `System.Linq.EnumerableQuery` in `System.Linq.Queryable, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EnumerableQuery
        {
            internal EnumerableQuery() => throw null;
        }

        // Generated from `System.Linq.EnumerableQuery<>` in `System.Linq.Queryable, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EnumerableQuery<T> : System.Linq.EnumerableQuery, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Linq.IOrderedQueryable, System.Linq.IOrderedQueryable<T>, System.Linq.IQueryProvider, System.Linq.IQueryable, System.Linq.IQueryable<T>
        {
            System.Linq.IQueryable System.Linq.IQueryProvider.CreateQuery(System.Linq.Expressions.Expression expression) => throw null;
            System.Linq.IQueryable<TElement> System.Linq.IQueryProvider.CreateQuery<TElement>(System.Linq.Expressions.Expression expression) => throw null;
            System.Type System.Linq.IQueryable.ElementType { get => throw null; }
            public EnumerableQuery(System.Linq.Expressions.Expression expression) => throw null;
            public EnumerableQuery(System.Collections.Generic.IEnumerable<T> enumerable) => throw null;
            object System.Linq.IQueryProvider.Execute(System.Linq.Expressions.Expression expression) => throw null;
            TElement System.Linq.IQueryProvider.Execute<TElement>(System.Linq.Expressions.Expression expression) => throw null;
            System.Linq.Expressions.Expression System.Linq.IQueryable.Expression { get => throw null; }
            System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            System.Linq.IQueryProvider System.Linq.IQueryable.Provider { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Linq.Queryable` in `System.Linq.Queryable, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Queryable
        {
            public static TResult Aggregate<TSource, TAccumulate, TResult>(this System.Linq.IQueryable<TSource> source, TAccumulate seed, System.Linq.Expressions.Expression<System.Func<TAccumulate, TSource, TAccumulate>> func, System.Linq.Expressions.Expression<System.Func<TAccumulate, TResult>> selector) => throw null;
            public static TAccumulate Aggregate<TSource, TAccumulate>(this System.Linq.IQueryable<TSource> source, TAccumulate seed, System.Linq.Expressions.Expression<System.Func<TAccumulate, TSource, TAccumulate>> func) => throw null;
            public static TSource Aggregate<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TSource, TSource>> func) => throw null;
            public static bool All<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static bool Any<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static bool Any<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static System.Linq.IQueryable<TSource> Append<TSource>(this System.Linq.IQueryable<TSource> source, TSource element) => throw null;
            public static System.Linq.IQueryable AsQueryable(this System.Collections.IEnumerable source) => throw null;
            public static System.Linq.IQueryable<TElement> AsQueryable<TElement>(this System.Collections.Generic.IEnumerable<TElement> source) => throw null;
            public static System.Decimal Average(this System.Linq.IQueryable<System.Decimal> source) => throw null;
            public static System.Decimal? Average(this System.Linq.IQueryable<System.Decimal?> source) => throw null;
            public static double Average(this System.Linq.IQueryable<double> source) => throw null;
            public static double? Average(this System.Linq.IQueryable<double?> source) => throw null;
            public static float Average(this System.Linq.IQueryable<float> source) => throw null;
            public static float? Average(this System.Linq.IQueryable<float?> source) => throw null;
            public static double Average(this System.Linq.IQueryable<int> source) => throw null;
            public static double? Average(this System.Linq.IQueryable<int?> source) => throw null;
            public static double Average(this System.Linq.IQueryable<System.Int64> source) => throw null;
            public static double? Average(this System.Linq.IQueryable<System.Int64?> source) => throw null;
            public static System.Decimal Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Decimal>> selector) => throw null;
            public static System.Decimal? Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Decimal?>> selector) => throw null;
            public static double Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double>> selector) => throw null;
            public static double? Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double?>> selector) => throw null;
            public static float Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float>> selector) => throw null;
            public static float? Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float?>> selector) => throw null;
            public static double Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int>> selector) => throw null;
            public static double? Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int?>> selector) => throw null;
            public static double Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Int64>> selector) => throw null;
            public static double? Average<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Int64?>> selector) => throw null;
            public static System.Linq.IQueryable<TResult> Cast<TResult>(this System.Linq.IQueryable source) => throw null;
            public static System.Linq.IQueryable<TSource[]> Chunk<TSource>(this System.Linq.IQueryable<TSource> source, int size) => throw null;
            public static System.Linq.IQueryable<TSource> Concat<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2) => throw null;
            public static bool Contains<TSource>(this System.Linq.IQueryable<TSource> source, TSource item) => throw null;
            public static bool Contains<TSource>(this System.Linq.IQueryable<TSource> source, TSource item, System.Collections.Generic.IEqualityComparer<TSource> comparer) => throw null;
            public static int Count<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static int Count<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static System.Linq.IQueryable<TSource> DefaultIfEmpty<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static System.Linq.IQueryable<TSource> DefaultIfEmpty<TSource>(this System.Linq.IQueryable<TSource> source, TSource defaultValue) => throw null;
            public static System.Linq.IQueryable<TSource> Distinct<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static System.Linq.IQueryable<TSource> Distinct<TSource>(this System.Linq.IQueryable<TSource> source, System.Collections.Generic.IEqualityComparer<TSource> comparer) => throw null;
            public static System.Linq.IQueryable<TSource> DistinctBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IQueryable<TSource> DistinctBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static TSource ElementAt<TSource>(this System.Linq.IQueryable<TSource> source, System.Index index) => throw null;
            public static TSource ElementAt<TSource>(this System.Linq.IQueryable<TSource> source, int index) => throw null;
            public static TSource ElementAtOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, System.Index index) => throw null;
            public static TSource ElementAtOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, int index) => throw null;
            public static System.Linq.IQueryable<TSource> Except<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2) => throw null;
            public static System.Linq.IQueryable<TSource> Except<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2, System.Collections.Generic.IEqualityComparer<TSource> comparer) => throw null;
            public static System.Linq.IQueryable<TSource> ExceptBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TKey> source2, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IQueryable<TSource> ExceptBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TKey> source2, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static TSource First<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static TSource First<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static TSource FirstOrDefault<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static TSource FirstOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static TSource FirstOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, TSource defaultValue) => throw null;
            public static TSource FirstOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, TSource defaultValue) => throw null;
            public static System.Linq.IQueryable<TResult> GroupBy<TSource, TKey, TElement, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Linq.Expressions.Expression<System.Func<TSource, TElement>> elementSelector, System.Linq.Expressions.Expression<System.Func<TKey, System.Collections.Generic.IEnumerable<TElement>, TResult>> resultSelector) => throw null;
            public static System.Linq.IQueryable<TResult> GroupBy<TSource, TKey, TElement, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Linq.Expressions.Expression<System.Func<TSource, TElement>> elementSelector, System.Linq.Expressions.Expression<System.Func<TKey, System.Collections.Generic.IEnumerable<TElement>, TResult>> resultSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<System.Linq.IGrouping<TKey, TElement>> GroupBy<TSource, TKey, TElement>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Linq.Expressions.Expression<System.Func<TSource, TElement>> elementSelector) => throw null;
            public static System.Linq.IQueryable<System.Linq.IGrouping<TKey, TElement>> GroupBy<TSource, TKey, TElement>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Linq.Expressions.Expression<System.Func<TSource, TElement>> elementSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<TResult> GroupBy<TSource, TKey, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Linq.Expressions.Expression<System.Func<TKey, System.Collections.Generic.IEnumerable<TSource>, TResult>> resultSelector) => throw null;
            public static System.Linq.IQueryable<TResult> GroupBy<TSource, TKey, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Linq.Expressions.Expression<System.Func<TKey, System.Collections.Generic.IEnumerable<TSource>, TResult>> resultSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<System.Linq.IGrouping<TKey, TSource>> GroupBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IQueryable<System.Linq.IGrouping<TKey, TSource>> GroupBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<TResult> GroupJoin<TOuter, TInner, TKey, TResult>(this System.Linq.IQueryable<TOuter> outer, System.Collections.Generic.IEnumerable<TInner> inner, System.Linq.Expressions.Expression<System.Func<TOuter, TKey>> outerKeySelector, System.Linq.Expressions.Expression<System.Func<TInner, TKey>> innerKeySelector, System.Linq.Expressions.Expression<System.Func<TOuter, System.Collections.Generic.IEnumerable<TInner>, TResult>> resultSelector) => throw null;
            public static System.Linq.IQueryable<TResult> GroupJoin<TOuter, TInner, TKey, TResult>(this System.Linq.IQueryable<TOuter> outer, System.Collections.Generic.IEnumerable<TInner> inner, System.Linq.Expressions.Expression<System.Func<TOuter, TKey>> outerKeySelector, System.Linq.Expressions.Expression<System.Func<TInner, TKey>> innerKeySelector, System.Linq.Expressions.Expression<System.Func<TOuter, System.Collections.Generic.IEnumerable<TInner>, TResult>> resultSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<TSource> Intersect<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2) => throw null;
            public static System.Linq.IQueryable<TSource> Intersect<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2, System.Collections.Generic.IEqualityComparer<TSource> comparer) => throw null;
            public static System.Linq.IQueryable<TSource> IntersectBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TKey> source2, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IQueryable<TSource> IntersectBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TKey> source2, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<TResult> Join<TOuter, TInner, TKey, TResult>(this System.Linq.IQueryable<TOuter> outer, System.Collections.Generic.IEnumerable<TInner> inner, System.Linq.Expressions.Expression<System.Func<TOuter, TKey>> outerKeySelector, System.Linq.Expressions.Expression<System.Func<TInner, TKey>> innerKeySelector, System.Linq.Expressions.Expression<System.Func<TOuter, TInner, TResult>> resultSelector) => throw null;
            public static System.Linq.IQueryable<TResult> Join<TOuter, TInner, TKey, TResult>(this System.Linq.IQueryable<TOuter> outer, System.Collections.Generic.IEnumerable<TInner> inner, System.Linq.Expressions.Expression<System.Func<TOuter, TKey>> outerKeySelector, System.Linq.Expressions.Expression<System.Func<TInner, TKey>> innerKeySelector, System.Linq.Expressions.Expression<System.Func<TOuter, TInner, TResult>> resultSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static TSource Last<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static TSource Last<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static TSource LastOrDefault<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static TSource LastOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static TSource LastOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, TSource defaultValue) => throw null;
            public static TSource LastOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, TSource defaultValue) => throw null;
            public static System.Int64 LongCount<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static System.Int64 LongCount<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static TResult Max<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TResult>> selector) => throw null;
            public static TSource Max<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static TSource Max<TSource>(this System.Linq.IQueryable<TSource> source, System.Collections.Generic.IComparer<TSource> comparer) => throw null;
            public static TSource MaxBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static TSource MaxBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IComparer<TSource> comparer) => throw null;
            public static TResult Min<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TResult>> selector) => throw null;
            public static TSource Min<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static TSource Min<TSource>(this System.Linq.IQueryable<TSource> source, System.Collections.Generic.IComparer<TSource> comparer) => throw null;
            public static TSource MinBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static TSource MinBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IComparer<TSource> comparer) => throw null;
            public static System.Linq.IQueryable<TResult> OfType<TResult>(this System.Linq.IQueryable source) => throw null;
            public static System.Linq.IOrderedQueryable<TSource> OrderBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IOrderedQueryable<TSource> OrderBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
            public static System.Linq.IOrderedQueryable<TSource> OrderByDescending<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IOrderedQueryable<TSource> OrderByDescending<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<TSource> Prepend<TSource>(this System.Linq.IQueryable<TSource> source, TSource element) => throw null;
            public static System.Linq.IQueryable<TSource> Reverse<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static System.Linq.IQueryable<TResult> Select<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TResult>> selector) => throw null;
            public static System.Linq.IQueryable<TResult> Select<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int, TResult>> selector) => throw null;
            public static System.Linq.IQueryable<TResult> SelectMany<TSource, TCollection, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Collections.Generic.IEnumerable<TCollection>>> collectionSelector, System.Linq.Expressions.Expression<System.Func<TSource, TCollection, TResult>> resultSelector) => throw null;
            public static System.Linq.IQueryable<TResult> SelectMany<TSource, TCollection, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int, System.Collections.Generic.IEnumerable<TCollection>>> collectionSelector, System.Linq.Expressions.Expression<System.Func<TSource, TCollection, TResult>> resultSelector) => throw null;
            public static System.Linq.IQueryable<TResult> SelectMany<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Collections.Generic.IEnumerable<TResult>>> selector) => throw null;
            public static System.Linq.IQueryable<TResult> SelectMany<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int, System.Collections.Generic.IEnumerable<TResult>>> selector) => throw null;
            public static bool SequenceEqual<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2) => throw null;
            public static bool SequenceEqual<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2, System.Collections.Generic.IEqualityComparer<TSource> comparer) => throw null;
            public static TSource Single<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static TSource Single<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static TSource SingleOrDefault<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
            public static TSource SingleOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static TSource SingleOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, TSource defaultValue) => throw null;
            public static TSource SingleOrDefault<TSource>(this System.Linq.IQueryable<TSource> source, TSource defaultValue) => throw null;
            public static System.Linq.IQueryable<TSource> Skip<TSource>(this System.Linq.IQueryable<TSource> source, int count) => throw null;
            public static System.Linq.IQueryable<TSource> SkipLast<TSource>(this System.Linq.IQueryable<TSource> source, int count) => throw null;
            public static System.Linq.IQueryable<TSource> SkipWhile<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static System.Linq.IQueryable<TSource> SkipWhile<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int, bool>> predicate) => throw null;
            public static System.Decimal Sum(this System.Linq.IQueryable<System.Decimal> source) => throw null;
            public static System.Decimal? Sum(this System.Linq.IQueryable<System.Decimal?> source) => throw null;
            public static double Sum(this System.Linq.IQueryable<double> source) => throw null;
            public static double? Sum(this System.Linq.IQueryable<double?> source) => throw null;
            public static float Sum(this System.Linq.IQueryable<float> source) => throw null;
            public static float? Sum(this System.Linq.IQueryable<float?> source) => throw null;
            public static int Sum(this System.Linq.IQueryable<int> source) => throw null;
            public static int? Sum(this System.Linq.IQueryable<int?> source) => throw null;
            public static System.Int64 Sum(this System.Linq.IQueryable<System.Int64> source) => throw null;
            public static System.Int64? Sum(this System.Linq.IQueryable<System.Int64?> source) => throw null;
            public static System.Decimal Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Decimal>> selector) => throw null;
            public static System.Decimal? Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Decimal?>> selector) => throw null;
            public static double Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double>> selector) => throw null;
            public static double? Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double?>> selector) => throw null;
            public static float Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float>> selector) => throw null;
            public static float? Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float?>> selector) => throw null;
            public static int Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int>> selector) => throw null;
            public static int? Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int?>> selector) => throw null;
            public static System.Int64 Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Int64>> selector) => throw null;
            public static System.Int64? Sum<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, System.Int64?>> selector) => throw null;
            public static System.Linq.IQueryable<TSource> Take<TSource>(this System.Linq.IQueryable<TSource> source, System.Range range) => throw null;
            public static System.Linq.IQueryable<TSource> Take<TSource>(this System.Linq.IQueryable<TSource> source, int count) => throw null;
            public static System.Linq.IQueryable<TSource> TakeLast<TSource>(this System.Linq.IQueryable<TSource> source, int count) => throw null;
            public static System.Linq.IQueryable<TSource> TakeWhile<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static System.Linq.IQueryable<TSource> TakeWhile<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int, bool>> predicate) => throw null;
            public static System.Linq.IOrderedQueryable<TSource> ThenBy<TSource, TKey>(this System.Linq.IOrderedQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IOrderedQueryable<TSource> ThenBy<TSource, TKey>(this System.Linq.IOrderedQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
            public static System.Linq.IOrderedQueryable<TSource> ThenByDescending<TSource, TKey>(this System.Linq.IOrderedQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IOrderedQueryable<TSource> ThenByDescending<TSource, TKey>(this System.Linq.IOrderedQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<TSource> Union<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2) => throw null;
            public static System.Linq.IQueryable<TSource> Union<TSource>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2, System.Collections.Generic.IEqualityComparer<TSource> comparer) => throw null;
            public static System.Linq.IQueryable<TSource> UnionBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector) => throw null;
            public static System.Linq.IQueryable<TSource> UnionBy<TSource, TKey>(this System.Linq.IQueryable<TSource> source1, System.Collections.Generic.IEnumerable<TSource> source2, System.Linq.Expressions.Expression<System.Func<TSource, TKey>> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
            public static System.Linq.IQueryable<TSource> Where<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
            public static System.Linq.IQueryable<TSource> Where<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int, bool>> predicate) => throw null;
            public static System.Linq.IQueryable<TResult> Zip<TFirst, TSecond, TResult>(this System.Linq.IQueryable<TFirst> source1, System.Collections.Generic.IEnumerable<TSecond> source2, System.Linq.Expressions.Expression<System.Func<TFirst, TSecond, TResult>> resultSelector) => throw null;
            public static System.Linq.IQueryable<(TFirst, TSecond, TThird)> Zip<TFirst, TSecond, TThird>(this System.Linq.IQueryable<TFirst> source1, System.Collections.Generic.IEnumerable<TSecond> source2, System.Collections.Generic.IEnumerable<TThird> source3) => throw null;
            public static System.Linq.IQueryable<(TFirst, TSecond)> Zip<TFirst, TSecond>(this System.Linq.IQueryable<TFirst> source1, System.Collections.Generic.IEnumerable<TSecond> source2) => throw null;
        }

    }
}
