// Generated automatically from org.apache.commons.collections4.set.UnmodifiableNavigableSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Collection;
import java.util.Iterator;
import java.util.NavigableSet;
import java.util.SortedSet;
import java.util.function.Predicate;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.set.AbstractNavigableSetDecorator;

public class UnmodifiableNavigableSet<E> extends AbstractNavigableSetDecorator<E> implements Unmodifiable
{
    protected UnmodifiableNavigableSet() {}
    public Iterator<E> descendingIterator(){ return null; }
    public Iterator<E> iterator(){ return null; }
    public NavigableSet<E> descendingSet(){ return null; }
    public NavigableSet<E> headSet(E p0, boolean p1){ return null; }
    public NavigableSet<E> subSet(E p0, boolean p1, E p2, boolean p3){ return null; }
    public NavigableSet<E> tailSet(E p0, boolean p1){ return null; }
    public SortedSet<E> headSet(E p0){ return null; }
    public SortedSet<E> subSet(E p0, E p1){ return null; }
    public SortedSet<E> tailSet(E p0){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <E> NavigableSet<E> unmodifiableNavigableSet(NavigableSet<E> p0){ return null; }
    public void clear(){}
}
