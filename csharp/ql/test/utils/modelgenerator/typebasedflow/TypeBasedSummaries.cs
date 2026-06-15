using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

namespace Summaries;

public class TypeBasedSimple<T>
{

    public T Prop
    {
        get { throw null; }
        set { throw null; }
    }

    // summary=Summaries;TypeBasedSimple<T>;false;TypeBasedSimple;(T);;Argument[0];Argument[this].SyntheticField[ArgType0];value;tb-generated
    public TypeBasedSimple(T t) { throw null; }

    // summary=Summaries;TypeBasedSimple<T>;false;Get;();;Argument[this].SyntheticField[ArgType0];ReturnValue;value;tb-generated
    public T Get() { throw null; }

    // summary=Summaries;TypeBasedSimple<T>;false;Get;(System.Object);;Argument[this].SyntheticField[ArgType0];ReturnValue;value;tb-generated
    public T Get(object x) { throw null; }

    // summary=Summaries;TypeBasedSimple<T>;false;Id;(T);;Argument[0];Argument[this].SyntheticField[ArgType0];value;tb-generated
    // summary=Summaries;TypeBasedSimple<T>;false;Id;(T);;Argument[0];ReturnValue;value;tb-generated
    // summary=Summaries;TypeBasedSimple<T>;false;Id;(T);;Argument[this].SyntheticField[ArgType0];ReturnValue;value;tb-generated
    public T Id(T x) { throw null; }

    // summary=Summaries;TypeBasedSimple<T>;false;Id<S>;(S);;Argument[0];ReturnValue;value;tb-generated
    public S Id<S>(S x) { throw null; }

    // summary=Summaries;TypeBasedSimple<T>;false;Set;(T);;Argument[0];Argument[this].SyntheticField[ArgType0];value;tb-generated
    public void Set(T x) { throw null; }

    // summary=Summaries;TypeBasedSimple<T>;false;Set;(System.Int32,T);;Argument[1];Argument[this].SyntheticField[ArgType0];value;tb-generated
    public void Set(int x, T y) { throw null; }

    // No summary as S is unrelated to T
    public void Set<S>(S x) { throw null; }
}

public class TypeBasedComplex<T>
{
    // summary=Summaries;TypeBasedComplex<T>;false;AddMany;(System.Collections.Generic.IEnumerable<T>);;Argument[0].Element;Argument[this].SyntheticField[ArgType0];value;tb-generated
    public void AddMany(IEnumerable<T> xs) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;Apply;(System.Func<T,System.Int32>);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
    public int Apply(Func<T, int> f) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;Apply<S>;(System.Func<T,S>);;Argument[0].ReturnValue;ReturnValue;value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;Apply<S>;(System.Func<T,S>);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
    public S Apply<S>(Func<T, S> f) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;Apply<T1,T2>;(T1,System.Func<T1,T2>);;Argument[0];Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;Apply<T1,T2>;(T1,System.Func<T1,T2>);;Argument[1].ReturnValue;ReturnValue;value;tb-generated
    public T2 Apply<T1, T2>(T1 x, Func<T1, T2> f) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;FlatMap;(System.Func<T,System.Collections.Generic.IEnumerable<T>>);;Argument[0].ReturnValue.Element;Argument[0].Parameter[0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;FlatMap;(System.Func<T,System.Collections.Generic.IEnumerable<T>>);;Argument[0].ReturnValue.Element;Argument[this].SyntheticField[ArgType0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;FlatMap;(System.Func<T,System.Collections.Generic.IEnumerable<T>>);;Argument[0].ReturnValue.Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;FlatMap;(System.Func<T,System.Collections.Generic.IEnumerable<T>>);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;FlatMap;(System.Func<T,System.Collections.Generic.IEnumerable<T>>);;Argument[this].SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;tb-generated
    public TypeBasedComplex<T> FlatMap(Func<T, IEnumerable<T>> f) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;FlatMap<S>;(System.Func<T,System.Collections.Generic.IEnumerable<S>>);;Argument[0].ReturnValue.Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;FlatMap<S>;(System.Func<T,System.Collections.Generic.IEnumerable<S>>);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
    public TypeBasedComplex<S> FlatMap<S>(Func<T, IEnumerable<S>> f) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;GetMany;();;Argument[this].SyntheticField[ArgType0];ReturnValue.Element;value;tb-generated
    public IList<T> GetMany() { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;Map<S>;(System.Func<T,S>);;Argument[0].ReturnValue;ReturnValue;value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;Map<S>;(System.Func<T,S>);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
    public S Map<S>(Func<T, S> f) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;MapComplex<S>;(System.Func<T,S>);;Argument[0].ReturnValue;ReturnValue.SyntheticField[ArgType0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;MapComplex<S>;(System.Func<T,S>);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
    public TypeBasedComplex<S> MapComplex<S>(Func<T, S> f) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;Return;(System.Func<T,Summaries.TypeBasedComplex<T>>);;Argument[0].ReturnValue.SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;Return;(System.Func<T,Summaries.TypeBasedComplex<T>>);;Argument[0].ReturnValue.SyntheticField[ArgType0];Argument[this].SyntheticField[ArgType0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;Return;(System.Func<T,Summaries.TypeBasedComplex<T>>);;Argument[0].ReturnValue.SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;Return;(System.Func<T,Summaries.TypeBasedComplex<T>>);;Argument[this].SyntheticField[ArgType0];Argument[0].Parameter[0];value;tb-generated
    // summary=Summaries;TypeBasedComplex<T>;false;Return;(System.Func<T,Summaries.TypeBasedComplex<T>>);;Argument[this].SyntheticField[ArgType0];ReturnValue.SyntheticField[ArgType0];value;tb-generated
    public TypeBasedComplex<T> Return(Func<T, TypeBasedComplex<T>> f) { throw null; }

    // summary=Summaries;TypeBasedComplex<T>;false;Set;(System.Int32,System.Func<System.Int32,T>);;Argument[1].ReturnValue;Argument[this].SyntheticField[ArgType0];value;tb-generated
    public void Set(int x, Func<int, T> f) { throw null; }
}

// It is assumed that this is a collection with elements of type T.
public class TypeBasedCollection<T> : IEnumerable<T>
{
    IEnumerator<T> IEnumerable<T>.GetEnumerator() { throw null; }
    IEnumerator IEnumerable.GetEnumerator() { throw null; }

    // summary=Summaries;TypeBasedCollection<T>;false;Add;(T);;Argument[0];Argument[this].Element;value;tb-generated
    public void Add(T x) { throw null; }

    // summary=Summaries;TypeBasedCollection<T>;false;AddMany;(System.Collections.Generic.IEnumerable<T>);;Argument[0].Element;Argument[this].Element;value;tb-generated
    public void AddMany(IEnumerable<T> x) { throw null; }

    // summary=Summaries;TypeBasedCollection<T>;false;First;();;Argument[this].Element;ReturnValue;value;tb-generated
    public T First() { throw null; }

    // summary=Summaries;TypeBasedCollection<T>;false;GetMany;();;Argument[this].Element;ReturnValue.Element;value;tb-generated
    public ICollection<T> GetMany() { throw null; }
}

// It is assumed that this is NOT a collection with elements of type T.
public class TypeBasedNoCollection<T> : IEnumerable
{
    IEnumerator IEnumerable.GetEnumerator() { throw null; }

    // summary=Summaries;TypeBasedNoCollection<T>;false;Get;();;Argument[this].SyntheticField[ArgType0];ReturnValue;value;tb-generated
    public T Get() { throw null; }

    // summary=Summaries;TypeBasedNoCollection<T>;false;Set;(T);;Argument[0];Argument[this].SyntheticField[ArgType0];value;tb-generated
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
public static class SystemLinqEnumerable
{
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TSource,TSource>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TSource,TSource>);;Argument[0].Element;Argument[1].Parameter[1];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TSource,TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TSource,TSource>);;Argument[1].ReturnValue;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TSource,TSource>);;Argument[1].ReturnValue;Argument[1].Parameter[1];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TSource,TSource>);;Argument[1].ReturnValue;ReturnValue;value;tb-generated
    public static TSource Aggregate<TSource>(this IEnumerable<TSource> source, Func<TSource, TSource, TSource> func) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>);;Argument[0].Element;Argument[2].Parameter[1];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>);;Argument[1];Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>);;Argument[1];ReturnValue;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>);;Argument[2].ReturnValue;Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>);;Argument[2].ReturnValue;ReturnValue;value;tb-generated
    public static TAccumulate Aggregate<TSource, TAccumulate>(this IEnumerable<TSource> source, TAccumulate seed, Func<TAccumulate, TSource, TAccumulate> func) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate,TResult>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>,System.Func<TAccumulate,TResult>);;Argument[0].Element;Argument[2].Parameter[1];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate,TResult>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>,System.Func<TAccumulate,TResult>);;Argument[1];Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate,TResult>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>,System.Func<TAccumulate,TResult>);;Argument[1];Argument[3].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate,TResult>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>,System.Func<TAccumulate,TResult>);;Argument[2].ReturnValue;Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate,TResult>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>,System.Func<TAccumulate,TResult>);;Argument[2].ReturnValue;Argument[3].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Aggregate<TSource,TAccumulate,TResult>;(System.Collections.Generic.IEnumerable<TSource>,TAccumulate,System.Func<TAccumulate,TSource,TAccumulate>,System.Func<TAccumulate,TResult>);;Argument[3].ReturnValue;ReturnValue;value;tb-generated
    public static TResult Aggregate<TSource, TAccumulate, TResult>(this IEnumerable<TSource> source, TAccumulate seed, Func<TAccumulate, TSource, TAccumulate> func, Func<TAccumulate, TResult> resultSelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;All<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    public static bool All<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }
    public static bool Any<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Any<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    public static bool Any<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Append<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Append<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[1];ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Append<TSource>(this IEnumerable<TSource> source, TSource element) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;AsEnumerable<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> AsEnumerable<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Average<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Decimal>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    public static decimal Average<TSource>(this IEnumerable<TSource> source, Func<TSource, decimal> selector) { throw null; }

    // Summary will not be derivables based on type information.
    // public static IEnumerable<TResult> Cast<TResult>(this IEnumerable source) { throw null; }
    public static IEnumerable<TSource[]> Chunk<TSource>(this IEnumerable<TSource> source, int size) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Concat<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Concat<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>);;Argument[1].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Concat<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }

    public static bool Contains<TSource>(this IEnumerable<TSource> source, TSource value) { throw null; }

    public static int Count<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Count<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    public static int Count<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;DefaultIfEmpty<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource?> DefaultIfEmpty<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;DefaultIfEmpty<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;DefaultIfEmpty<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[1];ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> DefaultIfEmpty<TSource>(this IEnumerable<TSource> source, TSource defaultValue) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;DistinctBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;DistinctBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Distinct<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Distinct<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;ElementAtOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Int32);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? ElementAtOrDefault<TSource>(this IEnumerable<TSource> source, int index) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;ElementAt<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Int32);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource ElementAt<TSource>(this IEnumerable<TSource> source, int index) { throw null; }

    public static IEnumerable<TResult> Empty<TResult>() { throw null; }

    // These summaries will not be derivable based on type information.
    // public static IEnumerable<TSource> ExceptBy<TSource, TKey>(this IEnumerable<TSource> first, IEnumerable<TKey> second, Func<TSource, TKey> keySelector) { throw null; }
    // public static IEnumerable<TSource> Except<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;FirstOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? FirstOrDefault<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;FirstOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[0].Element;ReturnValue;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;FirstOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[1];ReturnValue;value;tb-generated
    public static TSource FirstOrDefault<TSource>(this IEnumerable<TSource> source, TSource defaultValue) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;FirstOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;FirstOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? FirstOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // Summary will not be correctly derivable based on type information.
    // public static TSource FirstOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate, TSource defaultValue) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;First<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource First<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;First<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;First<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource First<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // Missing summary for Argument[0].Element -> Argument[2].Parameter[1].Element and similar problem for GroupJoin (issue with generator)
    // public static IEnumerable<TResult> GroupBy<TSource, TKey, TResult>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TKey, IEnumerable<TSource>, TResult> resultSelector) { throw null; }
    // public static IEnumerable<TResult> GroupJoin<TOuter, TInner, TKey, TResult>(this IEnumerable<TOuter> outer, IEnumerable<TInner> inner, Func<TOuter, TKey> outerKeySelector, Func<TInner, TKey> innerKeySelector, Func<TOuter, IEnumerable<TInner>, TResult> resultSelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;IntersectBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TKey>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;IntersectBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TKey>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> IntersectBy<TSource, TKey>(this IEnumerable<TSource> first, IEnumerable<TKey> second, Func<TSource, TKey> keySelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Intersect<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Intersect<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>);;Argument[1].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Intersect<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Join<TOuter,TInner,TKey,TResult>;(System.Collections.Generic.IEnumerable<TOuter>,System.Collections.Generic.IEnumerable<TInner>,System.Func<TOuter,TKey>,System.Func<TInner,TKey>,System.Func<TOuter,TInner,TResult>);;Argument[0].Element;Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Join<TOuter,TInner,TKey,TResult>;(System.Collections.Generic.IEnumerable<TOuter>,System.Collections.Generic.IEnumerable<TInner>,System.Func<TOuter,TKey>,System.Func<TInner,TKey>,System.Func<TOuter,TInner,TResult>);;Argument[0].Element;Argument[4].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Join<TOuter,TInner,TKey,TResult>;(System.Collections.Generic.IEnumerable<TOuter>,System.Collections.Generic.IEnumerable<TInner>,System.Func<TOuter,TKey>,System.Func<TInner,TKey>,System.Func<TOuter,TInner,TResult>);;Argument[1].Element;Argument[3].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Join<TOuter,TInner,TKey,TResult>;(System.Collections.Generic.IEnumerable<TOuter>,System.Collections.Generic.IEnumerable<TInner>,System.Func<TOuter,TKey>,System.Func<TInner,TKey>,System.Func<TOuter,TInner,TResult>);;Argument[1].Element;Argument[4].Parameter[1];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Join<TOuter,TInner,TKey,TResult>;(System.Collections.Generic.IEnumerable<TOuter>,System.Collections.Generic.IEnumerable<TInner>,System.Func<TOuter,TKey>,System.Func<TInner,TKey>,System.Func<TOuter,TInner,TResult>);;Argument[4].ReturnValue;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TResult> Join<TOuter, TInner, TKey, TResult>(this IEnumerable<TOuter> outer, IEnumerable<TInner> inner, Func<TOuter, TKey> outerKeySelector, Func<TInner, TKey> innerKeySelector, Func<TOuter, TInner, TResult> resultSelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;LastOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? LastOrDefault<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;LastOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[0].Element;ReturnValue;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;LastOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[1];ReturnValue;value;tb-generated
    public static TSource LastOrDefault<TSource>(this IEnumerable<TSource> source, TSource defaultValue) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;LastOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;LastOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? LastOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // Summary will not be correctly derivable based on type information (same problem as for FirstOrDefault)
    // public static TSource LastOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate, TSource defaultValue) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Last<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource Last<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Last<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Last<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource Last<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;LongCount<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    public static long LongCount<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;MaxBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;MaxBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? MaxBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Max<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? Max<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Max<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Decimal>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    public static decimal Max<TSource>(this IEnumerable<TSource> source, Func<TSource, decimal> selector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Max<TSource,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Max<TSource,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>);;Argument[1].ReturnValue;ReturnValue;value;tb-generated
    public static TResult? Max<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;MinBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;MinBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? MinBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Min<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? Min<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Min<TSource,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Min<TSource,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>);;Argument[1].ReturnValue;ReturnValue;value;tb-generated
    public static TResult? Min<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector) { throw null; }

    // These summaries will not be derivable based on type information.
    // public static IEnumerable<TResult> OfType<TResult>(this IEnumerable source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;OrderByDescending<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;OrderByDescending<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IOrderedEnumerable<TSource> OrderByDescending<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;OrderBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;OrderBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IOrderedEnumerable<TSource> OrderBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Prepend<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Prepend<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[1];ReturnValue.Element;value;tb-generated 
    public static IEnumerable<TSource> Prepend<TSource>(this IEnumerable<TSource> source, TSource element) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Repeat<TResult>;(TResult,System.Int32);;Argument[0];ReturnValue.Element;value;tb-generated
    public static IEnumerable<TResult> Repeat<TResult>(TResult element, int count) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Reverse<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Reverse<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;SelectMany<TSource,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Collections.Generic.IEnumerable<TResult>>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;SelectMany<TSource,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Collections.Generic.IEnumerable<TResult>>);;Argument[1].ReturnValue.Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TResult> SelectMany<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<TResult>> selector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;SelectMany<TSource,TCollection,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Collections.Generic.IEnumerable<TCollection>>,System.Func<TSource,TCollection,TResult>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;SelectMany<TSource,TCollection,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Collections.Generic.IEnumerable<TCollection>>,System.Func<TSource,TCollection,TResult>);;Argument[0].Element;Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;SelectMany<TSource,TCollection,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Collections.Generic.IEnumerable<TCollection>>,System.Func<TSource,TCollection,TResult>);;Argument[1].ReturnValue.Element;Argument[2].Parameter[1];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;SelectMany<TSource,TCollection,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Collections.Generic.IEnumerable<TCollection>>,System.Func<TSource,TCollection,TResult>);;Argument[2].ReturnValue;ReturnValue.Element;value;tb-generated 
    public static IEnumerable<TResult> SelectMany<TSource, TCollection, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<TCollection>> collectionSelector, Func<TSource, TCollection, TResult> resultSelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Select<TSource,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Select<TSource,TResult>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>);;Argument[1].ReturnValue;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TResult> Select<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector) { throw null; }

    public static bool SequenceEqual<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;SingleOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? SingleOrDefault<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;SingleOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[0].Element;ReturnValue;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;SingleOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,TSource);;Argument[1];ReturnValue;value;tb-generated
    public static TSource SingleOrDefault<TSource>(this IEnumerable<TSource> source, TSource defaultValue) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;SingleOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;SingleOrDefault<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource? SingleOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // Summary will not be correctly derivable based on type information (same problem as for FirstOrDefault)
    // public static TSource SingleOrDefault<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate, TSource defaultValue) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Single<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource Single<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Single<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Single<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue;value;tb-generated
    public static TSource Single<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;SkipLast<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Int32);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> SkipLast<TSource>(this IEnumerable<TSource> source, int count) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;SkipWhile<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;SkipWhile<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> SkipWhile<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Skip<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Int32);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Skip<TSource>(this IEnumerable<TSource> source, int count) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;TakeLast<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Int32);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> TakeLast<TSource>(this IEnumerable<TSource> source, int count) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;TakeWhile<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;TakeWhile<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> TakeWhile<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Take<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Int32);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Take<TSource>(this IEnumerable<TSource> source, int count) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;ThenByDescending<TSource,TKey>;(Summaries.IOrderedEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;ThenByDescending<TSource,TKey>;(Summaries.IOrderedEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IOrderedEnumerable<TSource> ThenByDescending<TSource, TKey>(this IOrderedEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;ThenBy<TSource,TKey>;(Summaries.IOrderedEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;ThenBy<TSource,TKey>;(Summaries.IOrderedEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IOrderedEnumerable<TSource> ThenBy<TSource, TKey>(this IOrderedEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }

    // Missing summary for Argument[0].Element -> ReturnValue.Element  (issue with generator)
    // public static TSource[] ToArray<TSource>(this IEnumerable<TSource> source) { throw null; }
    // Summaries related to dictionaries is not generated correctly as dictionaries are not identified as collections of keys and values (issue with generator).
    // public static Dictionary<TKey, TSource> ToDictionary<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) where TKey : notnull { throw null; }
    // public static Dictionary<TKey, TElement> ToDictionary<TSource, TKey, TElement>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector) where TKey : notnull { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;ToHashSet<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static HashSet<TSource> ToHashSet<TSource>(this IEnumerable<TSource> source) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;ToList<TSource>;(System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static List<TSource> ToList<TSource>(this IEnumerable<TSource> source) { throw null; }

    // Type to complicated to be handled by the generator (issue with generator).
    // public static ILookup<TKey, TSource> ToLookup<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector) { throw null; }
    // public static ILookup<TKey, TElement> ToLookup<TSource, TKey, TElement>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;UnionBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;UnionBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;UnionBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[1].Element;Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;UnionBy<TSource,TKey>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TKey>);;Argument[1].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> UnionBy<TSource, TKey>(this IEnumerable<TSource> first, IEnumerable<TSource> second, Func<TSource, TKey> keySelector) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Union<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Union<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Collections.Generic.IEnumerable<TSource>);;Argument[1].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Union<TSource>(this IEnumerable<TSource> first, IEnumerable<TSource> second) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Where<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Where<TSource>;(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Boolean>);;Argument[0].Element;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TSource> Where<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate) { throw null; }

    // Type to complicated to be handled by the generator (issue with generator).
    // public static IEnumerable<(TFirst First, TSecond Second)> Zip<TFirst, TSecond>(this IEnumerable<TFirst> first, IEnumerable<TSecond> second) { throw null; }
    // public static IEnumerable<(TFirst First, TSecond Second, TThird Third)> Zip<TFirst, TSecond, TThird>(this IEnumerable<TFirst> first, IEnumerable<TSecond> second, IEnumerable<TThird> third) { throw null; }

    // summary=Summaries;SystemLinqEnumerable;false;Zip<TFirst,TSecond,TResult>;(System.Collections.Generic.IEnumerable<TFirst>,System.Collections.Generic.IEnumerable<TSecond>,System.Func<TFirst,TSecond,TResult>);;Argument[0].Element;Argument[2].Parameter[0];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Zip<TFirst,TSecond,TResult>;(System.Collections.Generic.IEnumerable<TFirst>,System.Collections.Generic.IEnumerable<TSecond>,System.Func<TFirst,TSecond,TResult>);;Argument[1].Element;Argument[2].Parameter[1];value;tb-generated
    // summary=Summaries;SystemLinqEnumerable;false;Zip<TFirst,TSecond,TResult>;(System.Collections.Generic.IEnumerable<TFirst>,System.Collections.Generic.IEnumerable<TSecond>,System.Func<TFirst,TSecond,TResult>);;Argument[2].ReturnValue;ReturnValue.Element;value;tb-generated
    public static IEnumerable<TResult> Zip<TFirst, TSecond, TResult>(this IEnumerable<TFirst> first, IEnumerable<TSecond> second, Func<TFirst, TSecond, TResult> resultSelector) { throw null; }
}

public interface IGrouping<out TKey, out TElement> : IEnumerable<TElement>, IEnumerable
{
    // summary=Summaries;IGrouping<TKey,TElement>;true;get_Key;();;Argument[this].SyntheticField[ArgType0];ReturnValue;value;tb-generated
    TKey Key { get; }
}

// public interface ILookup<TKey, TElement> : IEnumerable<IGrouping<TKey, TElement>>, IEnumerable {
//     IEnumerable<TElement> this[TKey key] { get; }
//     bool Contains(TKey key);
// }

public interface IOrderedEnumerable<out TElement> : IEnumerable<TElement>, IEnumerable
{
    // summary=Summaries;IOrderedEnumerable<TElement>;true;CreateOrderedEnumerable<TKey>;(System.Func<TElement,TKey>,System.Collections.Generic.IComparer<TKey>,System.Boolean);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
    // summary=Summaries;IOrderedEnumerable<TElement>;true;CreateOrderedEnumerable<TKey>;(System.Func<TElement,TKey>,System.Collections.Generic.IComparer<TKey>,System.Boolean);;Argument[this].Element;ReturnValue.Element;value;tb-generated
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
