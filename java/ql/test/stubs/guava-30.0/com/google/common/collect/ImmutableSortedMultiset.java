// Generated automatically from com.google.common.collect.ImmutableSortedMultiset for testing purposes

package com.google.common.collect;

import com.google.common.collect.BoundType;
import com.google.common.collect.ImmutableMultiset;
import com.google.common.collect.ImmutableSortedMultisetFauxverideShim;
import com.google.common.collect.ImmutableSortedSet;
import com.google.common.collect.Multiset;
import com.google.common.collect.SortedMultiset;
import java.util.Comparator;
import java.util.Iterator;
import java.util.function.Function;
import java.util.function.ToIntFunction;
import java.util.stream.Collector;

abstract public class ImmutableSortedMultiset<E> extends ImmutableSortedMultisetFauxverideShim<E> implements SortedMultiset<E>
{
    public ImmutableSortedMultiset<E> descendingMultiset(){ return null; }
    public ImmutableSortedMultiset<E> subMultiset(E p0, BoundType p1, E p2, BoundType p3){ return null; }
    public abstract ImmutableSortedMultiset<E> headMultiset(E p0, BoundType p1);
    public abstract ImmutableSortedMultiset<E> tailMultiset(E p0, BoundType p1);
    public abstract ImmutableSortedSet<E> elementSet();
    public final Comparator<? super E> comparator(){ return null; }
    public final Multiset.Entry<E> pollFirstEntry(){ return null; }
    public final Multiset.Entry<E> pollLastEntry(){ return null; }
    public static <E extends Comparable<? extends Object>> ImmutableSortedMultiset.Builder<E> naturalOrder(){ return null; }
    public static <E extends Comparable<? extends Object>> ImmutableSortedMultiset.Builder<E> reverseOrder(){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedMultiset<E> copyOf(E[] p0){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedMultiset<E> of(E p0){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedMultiset<E> of(E p0, E p1){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedMultiset<E> of(E p0, E p1, E p2){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedMultiset<E> of(E p0, E p1, E p2, E p3){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedMultiset<E> of(E p0, E p1, E p2, E p3, E p4){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedMultiset<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E... p6){ return null; }
    public static <E> Collector<E, ? extends Object, ImmutableSortedMultiset<E>> toImmutableSortedMultiset(Comparator<? super E> p0){ return null; }
    public static <E> ImmutableSortedMultiset.Builder<E> orderedBy(Comparator<E> p0){ return null; }
    public static <E> ImmutableSortedMultiset<E> copyOf(Comparator<? super E> p0, Iterable<? extends E> p1){ return null; }
    public static <E> ImmutableSortedMultiset<E> copyOf(Comparator<? super E> p0, Iterator<? extends E> p1){ return null; }
    public static <E> ImmutableSortedMultiset<E> copyOf(Iterable<? extends E> p0){ return null; }
    public static <E> ImmutableSortedMultiset<E> copyOf(Iterator<? extends E> p0){ return null; }
    public static <E> ImmutableSortedMultiset<E> copyOfSorted(SortedMultiset<E> p0){ return null; }
    public static <E> ImmutableSortedMultiset<E> of(){ return null; }
    public static <T, E> Collector<T, ? extends Object, ImmutableSortedMultiset<E>> toImmutableSortedMultiset(Comparator<? super E> p0, Function<? super T, ? extends E> p1, ToIntFunction<? super T> p2){ return null; }
    static public class Builder<E> extends ImmutableMultiset.Builder<E>
    {
        protected Builder() {}
        public Builder(Comparator<? super E> p0){}
        public ImmutableSortedMultiset.Builder<E> add(E p0){ return null; }
        public ImmutableSortedMultiset.Builder<E> add(E... p0){ return null; }
        public ImmutableSortedMultiset.Builder<E> addAll(Iterable<? extends E> p0){ return null; }
        public ImmutableSortedMultiset.Builder<E> addAll(Iterator<? extends E> p0){ return null; }
        public ImmutableSortedMultiset.Builder<E> addCopies(E p0, int p1){ return null; }
        public ImmutableSortedMultiset.Builder<E> setCount(E p0, int p1){ return null; }
        public ImmutableSortedMultiset<E> build(){ return null; }
    }
}
