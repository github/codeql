// Generated automatically from org.apache.commons.collections4.set.TransformedNavigableSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Iterator;
import java.util.NavigableSet;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.set.TransformedSortedSet;

public class TransformedNavigableSet<E> extends TransformedSortedSet<E> implements NavigableSet<E>
{
    protected TransformedNavigableSet() {}
    protected NavigableSet<E> decorated(){ return null; }
    protected TransformedNavigableSet(NavigableSet<E> p0, Transformer<? super E, ? extends E> p1){}
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
    public static <E> TransformedNavigableSet<E> transformedNavigableSet(NavigableSet<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> TransformedNavigableSet<E> transformingNavigableSet(NavigableSet<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
}
