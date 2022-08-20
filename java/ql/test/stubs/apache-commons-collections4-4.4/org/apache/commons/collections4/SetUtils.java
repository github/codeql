// Generated automatically from org.apache.commons.collections4.SetUtils for testing purposes

package org.apache.commons.collections4;

import java.util.AbstractSet;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.NavigableSet;
import java.util.Set;
import java.util.SortedSet;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.Transformer;

public class SetUtils
{
    protected SetUtils() {}
    abstract static public class SetView<E> extends AbstractSet<E>
    {
        protected abstract Iterator<E> createIterator();
        public <S extends Set<E>> void copyInto(S p0){}
        public Iterator<E> iterator(){ return null; }
        public Set<E> toSet(){ return null; }
        public SetView(){}
        public int size(){ return 0; }
    }
    public static <E> HashSet<E> hashSet(E... p0){ return null; }
    public static <E> Set<E> emptySet(){ return null; }
    public static <E> Set<E> newIdentityHashSet(){ return null; }
    public static <E> Set<E> orderedSet(Set<E> p0){ return null; }
    public static <E> Set<E> predicatedSet(Set<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> Set<E> synchronizedSet(Set<E> p0){ return null; }
    public static <E> Set<E> transformedSet(Set<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> Set<E> unmodifiableSet(E... p0){ return null; }
    public static <E> Set<E> unmodifiableSet(Set<? extends E> p0){ return null; }
    public static <E> SetUtils.SetView<E> difference(Set<? extends E> p0, Set<? extends E> p1){ return null; }
    public static <E> SetUtils.SetView<E> disjunction(Set<? extends E> p0, Set<? extends E> p1){ return null; }
    public static <E> SetUtils.SetView<E> intersection(Set<? extends E> p0, Set<? extends E> p1){ return null; }
    public static <E> SetUtils.SetView<E> union(Set<? extends E> p0, Set<? extends E> p1){ return null; }
    public static <E> SortedSet<E> emptySortedSet(){ return null; }
    public static <E> SortedSet<E> predicatedNavigableSet(NavigableSet<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> SortedSet<E> predicatedSortedSet(SortedSet<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> SortedSet<E> synchronizedSortedSet(SortedSet<E> p0){ return null; }
    public static <E> SortedSet<E> transformedNavigableSet(NavigableSet<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> SortedSet<E> transformedSortedSet(SortedSet<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> SortedSet<E> unmodifiableNavigableSet(NavigableSet<E> p0){ return null; }
    public static <E> SortedSet<E> unmodifiableSortedSet(SortedSet<E> p0){ return null; }
    public static <T> Set<T> emptyIfNull(Set<T> p0){ return null; }
    public static <T> int hashCodeForSet(Collection<T> p0){ return 0; }
    public static SortedSet EMPTY_SORTED_SET = null;
    public static boolean isEqualSet(Collection<? extends Object> p0, Collection<? extends Object> p1){ return false; }
}
