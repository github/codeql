// Generated automatically from org.apache.commons.collections4.set.PredicatedSortedSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Comparator;
import java.util.SortedSet;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.set.PredicatedSet;

public class PredicatedSortedSet<E> extends PredicatedSet<E> implements SortedSet<E>
{
    protected PredicatedSortedSet() {}
    protected PredicatedSortedSet(SortedSet<E> p0, Predicate<? super E> p1){}
    protected SortedSet<E> decorated(){ return null; }
    public Comparator<? super E> comparator(){ return null; }
    public E first(){ return null; }
    public E last(){ return null; }
    public SortedSet<E> headSet(E p0){ return null; }
    public SortedSet<E> subSet(E p0, E p1){ return null; }
    public SortedSet<E> tailSet(E p0){ return null; }
    public static <E> PredicatedSortedSet<E> predicatedSortedSet(SortedSet<E> p0, Predicate<? super E> p1){ return null; }
}
