// Generated automatically from com.google.common.collect.ImmutableSortedSet for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableSet;
import com.google.common.collect.ImmutableSortedSetFauxverideShim;
import com.google.common.collect.RegularImmutableSortedSet;
import com.google.common.collect.SortedIterable;
import com.google.common.collect.UnmodifiableIterator;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.NavigableSet;
import java.util.SortedSet;
import java.util.Spliterator;
import java.util.stream.Collector;

abstract public class ImmutableSortedSet<E> extends ImmutableSortedSetFauxverideShim<E> implements NavigableSet<E>, SortedIterable<E>
{
    protected ImmutableSortedSet() {}
    ImmutableSortedSet(Comparator<? super E> p0){}
    ImmutableSortedSet<E> descendingSet = null;
    Object writeReplace(){ return null; }
    abstract ImmutableSortedSet<E> createDescendingSet();
    abstract ImmutableSortedSet<E> headSetImpl(E p0, boolean p1);
    abstract ImmutableSortedSet<E> subSetImpl(E p0, boolean p1, E p2, boolean p3);
    abstract ImmutableSortedSet<E> tailSetImpl(E p0, boolean p1);
    abstract int indexOf(Object p0);
    final Comparator<? super E> comparator = null;
    int unsafeCompare(Object p0, Object p1){ return 0; }
    public Comparator<? super E> comparator(){ return null; }
    public E ceiling(E p0){ return null; }
    public E first(){ return null; }
    public E floor(E p0){ return null; }
    public E higher(E p0){ return null; }
    public E last(){ return null; }
    public E lower(E p0){ return null; }
    public ImmutableSortedSet<E> descendingSet(){ return null; }
    public ImmutableSortedSet<E> headSet(E p0){ return null; }
    public ImmutableSortedSet<E> headSet(E p0, boolean p1){ return null; }
    public ImmutableSortedSet<E> subSet(E p0, E p1){ return null; }
    public ImmutableSortedSet<E> subSet(E p0, boolean p1, E p2, boolean p3){ return null; }
    public ImmutableSortedSet<E> tailSet(E p0){ return null; }
    public ImmutableSortedSet<E> tailSet(E p0, boolean p1){ return null; }
    public Spliterator<E> spliterator(){ return null; }
    public abstract UnmodifiableIterator<E> descendingIterator();
    public abstract UnmodifiableIterator<E> iterator();
    public final E pollFirst(){ return null; }
    public final E pollLast(){ return null; }
    public static <E extends Comparable<? extends Object>> ImmutableSortedSet.Builder<E> naturalOrder(){ return null; }
    public static <E extends Comparable<? extends Object>> ImmutableSortedSet.Builder<E> reverseOrder(){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedSet<E> copyOf(E[] p0){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E p0){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E p0, E p1){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E p0, E p1, E p2){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E p0, E p1, E p2, E p3){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E p0, E p1, E p2, E p3, E p4){ return null; }
    public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E... p6){ return null; }
    public static <E> Collector<E, ? extends Object, ImmutableSortedSet<E>> toImmutableSortedSet(Comparator<? super E> p0){ return null; }
    public static <E> ImmutableSortedSet.Builder<E> orderedBy(Comparator<E> p0){ return null; }
    public static <E> ImmutableSortedSet<E> copyOf(Collection<? extends E> p0){ return null; }
    public static <E> ImmutableSortedSet<E> copyOf(Comparator<? super E> p0, Collection<? extends E> p1){ return null; }
    public static <E> ImmutableSortedSet<E> copyOf(Comparator<? super E> p0, Iterable<? extends E> p1){ return null; }
    public static <E> ImmutableSortedSet<E> copyOf(Comparator<? super E> p0, Iterator<? extends E> p1){ return null; }
    public static <E> ImmutableSortedSet<E> copyOf(Iterable<? extends E> p0){ return null; }
    public static <E> ImmutableSortedSet<E> copyOf(Iterator<? extends E> p0){ return null; }
    public static <E> ImmutableSortedSet<E> copyOfSorted(SortedSet<E> p0){ return null; }
    public static <E> ImmutableSortedSet<E> of(){ return null; }
    static <E> ImmutableSortedSet<E> construct(Comparator<? super E> p0, int p1, E... p2){ return null; }
    static <E> RegularImmutableSortedSet<E> emptySet(Comparator<? super E> p0){ return null; }
    static int SPLITERATOR_CHARACTERISTICS = 0;
    static int unsafeCompare(Comparator<? extends Object> p0, Object p1, Object p2){ return 0; }
    static public class Builder<E> extends ImmutableSet.Builder<E>
    {
        protected Builder() {}
        ImmutableSortedSet.Builder<E> combine(ImmutableSet.Builder<E> p0){ return null; }
        public Builder(Comparator<? super E> p0){}
        public ImmutableSortedSet.Builder<E> add(E p0){ return null; }
        public ImmutableSortedSet.Builder<E> add(E... p0){ return null; }
        public ImmutableSortedSet.Builder<E> addAll(Iterable<? extends E> p0){ return null; }
        public ImmutableSortedSet.Builder<E> addAll(Iterator<? extends E> p0){ return null; }
        public ImmutableSortedSet<E> build(){ return null; }
        void copy(){}
    }
}
