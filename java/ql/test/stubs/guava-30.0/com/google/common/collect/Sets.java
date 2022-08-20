// Generated automatically from com.google.common.collect.Sets for testing purposes, and adjusted manually

package com.google.common.collect;

import com.google.common.base.Predicate;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Range;
import com.google.common.collect.UnmodifiableIterator;
import java.util.AbstractSet;
import java.util.Collection;
import java.util.Comparator;
import java.util.EnumSet;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.NavigableSet;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.stream.Collector;

public class Sets
{
    protected Sets() {}
    abstract static public class SetView<E> extends AbstractSet<E>
    {
        protected SetView() {}
        public <S extends Set<E>> S copyInto(S p0){ return null; }
        public ImmutableSet<E> immutableCopy(){ return null; }
        public abstract UnmodifiableIterator<E> iterator();
        public final boolean add(E p0){ return false; }
        public final boolean addAll(Collection<? extends E> p0){ return false; }
        public final boolean remove(Object p0){ return false; }
        public final boolean removeAll(Collection<? extends Object> p0){ return false; }
        public final boolean removeIf(Predicate<? super E> p0){ return false; }
        public final boolean retainAll(Collection<? extends Object> p0){ return false; }
        public final void clear(){}
    }
    public static <B> Set<List<B>> cartesianProduct(List<? extends Set<? extends B>> p0){ return null; }
    public static <B> Set<List<B>> cartesianProduct(Set<? extends B>... p0){ return null; }
    public static <E extends Comparable> TreeSet<E> newTreeSet(){ return null; }
    public static <E extends Comparable> TreeSet<E> newTreeSet(Iterable<? extends E> p0){ return null; }
    public static <E extends Enum<E>> Collector<E, ? extends Object, ImmutableSet<E>> toImmutableEnumSet(){ return null; }
    public static <E extends Enum<E>> EnumSet<E> complementOf(Collection<E> p0){ return null; }
    public static <E extends Enum<E>> EnumSet<E> complementOf(Collection<E> p0, Class<E> p1){ return null; }
    public static <E extends Enum<E>> EnumSet<E> newEnumSet(Iterable<E> p0, Class<E> p1){ return null; }
    public static <E extends Enum<E>> ImmutableSet<E> immutableEnumSet(E p0, E... p1){ return null; }
    public static <E extends Enum<E>> ImmutableSet<E> immutableEnumSet(Iterable<E> p0){ return null; }
    public static <E> CopyOnWriteArraySet<E> newCopyOnWriteArraySet(){ return null; }
    public static <E> CopyOnWriteArraySet<E> newCopyOnWriteArraySet(Iterable<? extends E> p0){ return null; }
    public static <E> HashSet<E> newHashSet(){ return null; }
    public static <E> HashSet<E> newHashSet(E... p0){ return null; }
    public static <E> HashSet<E> newHashSet(Iterable<? extends E> p0){ return null; }
    public static <E> HashSet<E> newHashSet(Iterator<? extends E> p0){ return null; }
    public static <E> HashSet<E> newHashSetWithExpectedSize(int p0){ return null; }
    public static <E> LinkedHashSet<E> newLinkedHashSet(){ return null; }
    public static <E> LinkedHashSet<E> newLinkedHashSet(Iterable<? extends E> p0){ return null; }
    public static <E> LinkedHashSet<E> newLinkedHashSetWithExpectedSize(int p0){ return null; }
    public static <E> NavigableSet<E> filter(NavigableSet<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> NavigableSet<E> synchronizedNavigableSet(NavigableSet<E> p0){ return null; }
    public static <E> NavigableSet<E> unmodifiableNavigableSet(NavigableSet<E> p0){ return null; }
    public static <E> Set<E> filter(Set<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> Set<E> newConcurrentHashSet(){ return null; }
    public static <E> Set<E> newConcurrentHashSet(Iterable<? extends E> p0){ return null; }
    public static <E> Set<E> newIdentityHashSet(){ return null; }
    public static <E> Set<E> newSetFromMap(Map<E, Boolean> p0){ return null; }
    public static <E> Set<Set<E>> combinations(Set<E> p0, int p1){ return null; }
    public static <E> Set<Set<E>> powerSet(Set<E> p0){ return null; }
    public static <E> Sets.SetView<E> difference(Set<E> p0, Set<? extends Object> p1){ return null; }
    public static <E> Sets.SetView<E> intersection(Set<E> p0, Set<? extends Object> p1){ return null; }
    public static <E> Sets.SetView<E> symmetricDifference(Set<? extends E> p0, Set<? extends E> p1){ return null; }
    public static <E> Sets.SetView<E> union(Set<? extends E> p0, Set<? extends E> p1){ return null; }
    public static <E> SortedSet<E> filter(SortedSet<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> TreeSet<E> newTreeSet(Comparator<? super E> p0){ return null; }
    public static <K extends Comparable<? super K>> NavigableSet<K> subSet(NavigableSet<K> p0, Range<K> p1){ return null; }
}
