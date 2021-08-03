// Generated automatically from com.google.common.collect.Multisets for testing purposes

package com.google.common.collect;

import com.google.common.base.Predicate;
import com.google.common.collect.ImmutableMultiset;
import com.google.common.collect.Multiset;
import com.google.common.collect.SortedMultiset;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.function.ToIntFunction;
import java.util.stream.Collector;

public class Multisets
{
    protected Multisets() {}
    public static <E> ImmutableMultiset<E> copyHighestCountFirst(Multiset<E> p0){ return null; }
    public static <E> Multiset.Entry<E> immutableEntry(E p0, int p1){ return null; }
    public static <E> Multiset<E> difference(Multiset<E> p0, Multiset<? extends Object> p1){ return null; }
    public static <E> Multiset<E> filter(Multiset<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> Multiset<E> intersection(Multiset<E> p0, Multiset<? extends Object> p1){ return null; }
    public static <E> Multiset<E> sum(Multiset<? extends E> p0, Multiset<? extends E> p1){ return null; }
    public static <E> Multiset<E> union(Multiset<? extends E> p0, Multiset<? extends E> p1){ return null; }
    public static <E> Multiset<E> unmodifiableMultiset(ImmutableMultiset<E> p0){ return null; }
    public static <E> Multiset<E> unmodifiableMultiset(Multiset<? extends E> p0){ return null; }
    public static <E> SortedMultiset<E> unmodifiableSortedMultiset(SortedMultiset<E> p0){ return null; }
    public static <T, E, M extends Multiset<E>> Collector<T, ? extends Object, M> toMultiset(Function<? super T, E> p0, ToIntFunction<? super T> p1, Supplier<M> p2){ return null; }
    public static boolean containsOccurrences(Multiset<? extends Object> p0, Multiset<? extends Object> p1){ return false; }
    public static boolean removeOccurrences(Multiset<? extends Object> p0, Iterable<? extends Object> p1){ return false; }
    public static boolean removeOccurrences(Multiset<? extends Object> p0, Multiset<? extends Object> p1){ return false; }
    public static boolean retainOccurrences(Multiset<? extends Object> p0, Multiset<? extends Object> p1){ return false; }
}
