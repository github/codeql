using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

namespace Summaries;

public class TypeBasedSimple<T> {
    
    public T Prop {
        get { throw null; }
        set { throw null; }
    }

    public TypeBasedSimple(T t)  { throw null; } 

    public T Get() { throw null; }

    public T Get(object x) { throw null; }

    public T Id(T x) { throw null; }

    public S Id<S>(S x) { throw null; }

    public void Set(T x) { throw null; }

    public void Set(int x, T y) { throw null; }

    public void Set<S>(S x) { throw null; } // No summary as S is unrelated to T
}

public class TypeBasedComplex<T> {

    public void AddMany(IEnumerable<T> xs) { throw null; }

    public int Apply(Func<T, int> f) { throw null; }

    public S Apply<S>(Func<T, S> f) { throw null; }

    public T2 Apply<T1,T2>(T1 x, Func<T1, T2> f) { throw null; }

    public TypeBasedComplex<T> FlatMap(Func<T, IEnumerable<T>> f) { throw null; }

    public TypeBasedComplex<S> FlatMap<S>(Func<T, IEnumerable<S>> f) { throw null; }

    public IList<T> GetMany() { throw null; }

    public S Map<S>(Func<T, S> f) { throw null; }

    public TypeBasedComplex<S> MapComplex<S>(Func<T, S> f) { throw null; }

    public TypeBasedComplex<T> Return(Func<T, TypeBasedComplex<T>> f) { throw null; }
    
    public void Set(int x, Func<int, T> f) { throw null;}
}

// It is assumed that this is a collection with elements of type T.
public class TypeBasedCollection<T> : IEnumerable<T> {
    IEnumerator<T> IEnumerable<T>.GetEnumerator() { throw null; }
    IEnumerator IEnumerable.GetEnumerator() { throw null; }

    public void Add(T x) { throw null; }

    public void AddMany(IEnumerable<T> x) { throw null; }

    public T First() { throw null; }

    public ICollection<T> GetMany() { throw null; }
}

// It is assumed that this is NOT a collection with elements of type T.
public class TypeBasedNoCollection<T> : IEnumerable {
    IEnumerator IEnumerable.GetEnumerator() { throw null; }

    public T Get() { throw null; }

    public void Set(T x) { throw null; }
}

/* 
 * Representative subset of Linq.
 *
 * Only methods that will get summaries generated correctly are commented in.
 * The remaning methods and interfaces are commented out with a descriptive reason.
 * In some cases we will not be able correctly generate a summary based purely on the
 * type information.
 */
public static class SystemLinqEnumerable {

    public static TSource Aggregate<TSource>(this IEnumerable<TSource> source, Func<TSource, TSource, TSource> func) { throw null; }
    public static TAccumulate Aggregate<TSource, TAccumulate>(this IEnumerable<TSource> source, TAccumulate seed, Func<TAccumulate, TSource, TAccumulate> func) { throw null; }
    public static TResult Aggregate<TSource, TAccumulate, TResult>(this IEnumerable<TSource> source, TAccumulate seed, Func<TAccumulate, TSource, TAccumulate> func, Func<TAccumulate, TResult> resultSelector) { throw null; }
    public static bool All<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static bool Any<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static bool Any<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static IEnumerable<TSource> Append<TSource>(this IEnumerable<TSource> source, TSource element) { throw null; }
    public static IEnumerable<TSource> AsEnumerable<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static decimal Average<TSource>(this IEnumerable<TSource> source, Func<TSource, decimal> selector) { throw null; }
    // Summary will not be derivables based on type information.
    // public static IEnumerable<TResult> Cast<TResult>(this IEnumerable source) { throw null; }
    public static IEnumerable<TSource[]> Chunk<TSource>(this IEnumerable<TSource> source, int size) { throw null; }
    public static IEnumerable<TSource> Concat<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }
    public static bool Contains<TSource>(this IEnumerable<TSource> source, TSource value) { throw null; }
    public static int Count<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static int Count<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static IEnumerable<TSource?> DefaultIfEmpty<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static IEnumerable<TSource> DefaultIfEmpty<TSource>(this IEnumerable<TSource> source, TSource defaultValue) { throw null; }
    public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    public static IEnumerable<TSource> Distinct<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static TSource? ElementAtOrDefault<TSource>(this IEnumerable<TSource> source, int index) { throw null; }
    public static TSource ElementAt<TSource>(this IEnumerable<TSource> source, int index) { throw null; }
    public static IEnumerable<TResult> Empty<TResult>() { throw null; }
    // These summaries will not be derivable based on type information.
    // public static IEnumerable<TSource> ExceptBy<TSource, TKey>(this IEnumerable<TSource> first, IEnumerable<TKey> second, Func<TSource, TKey> keySelector) { throw null; }
    // public static IEnumerable<TSource> Except<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }
    public static TSource? FirstOrDefault<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static TSource FirstOrDefault<TSource>(this IEnumerable<TSource> source, TSource defaultValue) { throw null; }
    public static TSource? FirstOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    // Summary will not be correctly derivable based on type information.
    // public static TSource FirstOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate, TSource defaultValue) { throw null; }
    public static TSource First<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static TSource First<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    // Missing summary for Argument[0].Element -> Argument[2].Parameter[1].Element and similar problem for GroupJoin (issue with generator)
    // public static IEnumerable<TResult> GroupBy<TSource, TKey, TResult>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TKey, IEnumerable<TSource>, TResult> resultSelector) { throw null; }
    // public static IEnumerable<TResult> GroupJoin<TOuter, TInner, TKey, TResult>(this IEnumerable<TOuter> outer, IEnumerable<TInner> inner, Func<TOuter, TKey> outerKeySelector, Func<TInner, TKey> innerKeySelector, Func<TOuter, IEnumerable<TInner>, TResult> resultSelector) { throw null; }
    public static IEnumerable<TSource> IntersectBy<TSource, TKey>(this IEnumerable<TSource> first, IEnumerable<TKey> second, Func<TSource, TKey> keySelector) { throw null; }
    public static IEnumerable<TSource> Intersect<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }
    public static IEnumerable<TResult> Join<TOuter, TInner, TKey, TResult>(this IEnumerable<TOuter> outer, IEnumerable<TInner> inner, Func<TOuter, TKey> outerKeySelector, Func<TInner, TKey> innerKeySelector, Func<TOuter, TInner, TResult> resultSelector) { throw null; }
    public static TSource? LastOrDefault<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static TSource LastOrDefault<TSource>(this IEnumerable<TSource> source, TSource defaultValue) { throw null; }
    public static TSource? LastOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    // Summary will not be correctly derivable based on type information (same problem as for FirstOrDefault)
    // public static TSource LastOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate, TSource defaultValue) { throw null; }
    public static TSource Last<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static TSource Last<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static long LongCount<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static TSource? MaxBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    public static TSource? Max<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static decimal Max<TSource>(this IEnumerable<TSource> source, Func<TSource, decimal> selector) { throw null; }
    public static TResult? Max<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector) { throw null; }
    public static TSource? MinBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    public static TSource? Min<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static TResult? Min<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector) { throw null; }
    // These summaries will not be derivable based on type information.
    // public static IEnumerable<TResult> OfType<TResult>(this IEnumerable source) { throw null; }
    public static IOrderedEnumerable<TSource> OrderByDescending<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    public static IOrderedEnumerable<TSource> OrderBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    public static IEnumerable<TSource> Prepend<TSource>(this IEnumerable<TSource> source, TSource element) { throw null; }
    public static IEnumerable<TResult> Repeat<TResult>(TResult element, int count) { throw null; }
    public static IEnumerable<TSource> Reverse<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static IEnumerable<TResult> SelectMany<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<TResult>> selector) { throw null; }
    public static IEnumerable<TResult> SelectMany<TSource, TCollection, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<TCollection>> collectionSelector, Func<TSource, TCollection, TResult> resultSelector) { throw null; }
    public static IEnumerable<TResult> Select<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector) { throw null; }
    public static bool SequenceEqual<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }
    public static TSource? SingleOrDefault<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static TSource SingleOrDefault<TSource>(this IEnumerable<TSource> source, TSource defaultValue) { throw null; }
    public static TSource? SingleOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    // Summary will not be correctly derivable based on type information (same problem as for FirstOrDefault)
    // public static TSource SingleOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate, TSource defaultValue) { throw null; }
    public static TSource Single<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static TSource Single<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static IEnumerable<TSource> SkipLast<TSource>(this IEnumerable<TSource> source, int count) { throw null; }
    public static IEnumerable<TSource> SkipWhile<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static IEnumerable<TSource> Skip<TSource>(this IEnumerable<TSource> source, int count) { throw null; }
    public static IEnumerable<TSource> TakeLast<TSource>(this IEnumerable<TSource> source, int count) { throw null; }
    public static IEnumerable<TSource> TakeWhile<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static IEnumerable<TSource> Take<TSource>(this IEnumerable<TSource> source, int count) { throw null; }
    public static IOrderedEnumerable<TSource> ThenByDescending<TSource, TKey>(this IOrderedEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    public static IOrderedEnumerable<TSource> ThenBy<TSource, TKey>(this IOrderedEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    // Missing summary for Argument[0].Element -> ReturnValue.Element  (issue with generator)
    // public static TSource[] ToArray<TSource>(this IEnumerable<TSource> source) { throw null; }
    // Summaries related to dictionaries is not generated correctly as dictionaries are not identified as collections of keys and values (issue with generator).
    // public static Dictionary<TKey, TSource> ToDictionary<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) where TKey : notnull { throw null; }
    // public static Dictionary<TKey, TElement> ToDictionary<TSource, TKey, TElement>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector) where TKey : notnull { throw null; }
    public static HashSet<TSource> ToHashSet<TSource>(this IEnumerable<TSource> source) { throw null; }
    public static List<TSource> ToList<TSource>(this IEnumerable<TSource> source) { throw null; }
    // Type to complicated to be handled by the generator (issue with generator).
    // public static ILookup<TKey, TSource> ToLookup<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    // public static ILookup<TKey, TElement> ToLookup<TSource, TKey, TElement>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector) { throw null; }
    public static IEnumerable<TSource> UnionBy<TSource, TKey>(this IEnumerable<TSource> first, IEnumerable<TSource> second, Func<TSource, TKey> keySelector) { throw null; }
    public static IEnumerable<TSource> Union<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }
    public static IEnumerable<TSource> Where<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    // Type to complicated to be handled by the generator (issue with generator).
    // public static IEnumerable<(TFirst First, TSecond Second)> Zip<TFirst, TSecond>(this IEnumerable<TFirst> first, IEnumerable<TSecond> second) { throw null; }
    // public static IEnumerable<(TFirst First, TSecond Second, TThird Third)> Zip<TFirst, TSecond, TThird>(this IEnumerable<TFirst> first, IEnumerable<TSecond> second, IEnumerable<TThird> third) { throw null; }
    public static IEnumerable<TResult> Zip<TFirst, TSecond, TResult>(this IEnumerable<TFirst> first, IEnumerable<TSecond> second, Func<TFirst, TSecond, TResult> resultSelector) { throw null; }
}

public interface IGrouping<out TKey, out TElement> : IEnumerable<TElement>, IEnumerable {
    TKey Key { get; }
}

// public interface ILookup<TKey, TElement> : IEnumerable<IGrouping<TKey, TElement>>, IEnumerable {
//     IEnumerable<TElement> this[TKey key] { get; }
//     bool Contains(TKey key);
// }

public interface IOrderedEnumerable<out TElement> : IEnumerable<TElement>, IEnumerable {
    IOrderedEnumerable<TElement> CreateOrderedEnumerable<TKey>(Func<TElement, TKey> keySelector, IComparer<TKey>? comparer, bool descending);
}

// public partial class Lookup<TKey, TElement> : IEnumerable<IGrouping<TKey, TElement>>, IEnumerable, ILookup<TKey, TElement>{
//         internal Lookup() { }
//         public int Count { get { throw null; } }
//         public IEnumerable<TElement> this[TKey key] { get { throw null; } }
//         public IEnumerable<TResult> ApplyResultSelector<TResult>(Func<TKey, IEnumerable<TElement>, TResult> resultSelector) { throw null; }
//         public bool Contains(TKey key) { throw null; }
//         public IEnumerator<IGrouping<TKey, TElement>> GetEnumerator() { throw null; }
//         IEnumerator IEnumerable.GetEnumerator() { throw null; }
// }
