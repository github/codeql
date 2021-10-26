// Generated automatically from org.apache.commons.collections4.set.PredicatedNavigableSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Iterator;
import java.util.NavigableSet;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.set.PredicatedSortedSet;

public class PredicatedNavigableSet<E> extends PredicatedSortedSet<E> implements NavigableSet<E>
{
    protected PredicatedNavigableSet() {}
    protected NavigableSet<E> decorated(){ return null; }
    protected PredicatedNavigableSet(NavigableSet<E> p0, Predicate<? super E> p1){}
    public E ceiling(E p0){ return null; }
    public E floor(E p0){ return null; }
    public E higher(E p0){ return null; }
    public E lower(E p0){ return null; }
    public E pollFirst(){ return null; }
    public E pollLast(){ return null; }
    public Iterator<E> descendingIterator(){ return null; }
    public NavigableSet<E> descendingSet(){ return null; }
    public NavigableSet<E> headSet(E p0, boolean p1){ return null; }
    public NavigableSet<E> subSet(E p0, boolean p1, E p2, boolean p3){ return null; }
    public NavigableSet<E> tailSet(E p0, boolean p1){ return null; }
    public static <E> PredicatedNavigableSet<E> predicatedNavigableSet(NavigableSet<E> p0, Predicate<? super E> p1){ return null; }
}
