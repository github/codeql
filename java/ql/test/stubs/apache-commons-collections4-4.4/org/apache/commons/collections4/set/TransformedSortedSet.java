// Generated automatically from org.apache.commons.collections4.set.TransformedSortedSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Comparator;
import java.util.SortedSet;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.set.TransformedSet;

public class TransformedSortedSet<E> extends TransformedSet<E> implements SortedSet<E>
{
    protected TransformedSortedSet() {}
    protected SortedSet<E> getSortedSet(){ return null; }
    protected TransformedSortedSet(SortedSet<E> p0, Transformer<? super E, ? extends E> p1){}
    public Comparator<? super E> comparator(){ return null; }
    public E first(){ return null; }
    public E last(){ return null; }
    public SortedSet<E> headSet(E p0){ return null; }
    public SortedSet<E> subSet(E p0, E p1){ return null; }
    public SortedSet<E> tailSet(E p0){ return null; }
    public static <E> TransformedSortedSet<E> transformedSortedSet(SortedSet<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> TransformedSortedSet<E> transformingSortedSet(SortedSet<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
}
