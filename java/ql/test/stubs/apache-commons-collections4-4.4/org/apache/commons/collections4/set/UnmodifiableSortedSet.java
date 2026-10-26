// Generated automatically from org.apache.commons.collections4.set.UnmodifiableSortedSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Collection;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.function.Predicate;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.set.AbstractSortedSetDecorator;

public class UnmodifiableSortedSet<E> extends AbstractSortedSetDecorator<E> implements Unmodifiable
{
    protected UnmodifiableSortedSet() {}
    public Iterator<E> iterator(){ return null; }
    public SortedSet<E> headSet(E p0){ return null; }
    public SortedSet<E> subSet(E p0, E p1){ return null; }
    public SortedSet<E> tailSet(E p0){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <E> SortedSet<E> unmodifiableSortedSet(SortedSet<E> p0){ return null; }
    public void clear(){}
}
