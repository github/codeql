// Generated automatically from org.apache.commons.collections4.bag.TransformedSortedBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Comparator;
import org.apache.commons.collections4.SortedBag;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.bag.TransformedBag;

public class TransformedSortedBag<E> extends TransformedBag<E> implements SortedBag<E>
{
    protected TransformedSortedBag() {}
    protected SortedBag<E> getSortedBag(){ return null; }
    protected TransformedSortedBag(SortedBag<E> p0, Transformer<? super E, ? extends E> p1){}
    public Comparator<? super E> comparator(){ return null; }
    public E first(){ return null; }
    public E last(){ return null; }
    public static <E> TransformedSortedBag<E> transformedSortedBag(SortedBag<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> TransformedSortedBag<E> transformingSortedBag(SortedBag<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
}
