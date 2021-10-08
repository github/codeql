// Generated automatically from org.apache.commons.collections4.bag.SynchronizedSortedBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Comparator;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.SortedBag;
import org.apache.commons.collections4.bag.SynchronizedBag;

public class SynchronizedSortedBag<E> extends SynchronizedBag<E> implements SortedBag<E>
{
    protected SynchronizedSortedBag() {}
    protected SortedBag<E> getSortedBag(){ return null; }
    protected SynchronizedSortedBag(Bag<E> p0, Object p1){}
    protected SynchronizedSortedBag(SortedBag<E> p0){}
    public Comparator<? super E> comparator(){ return null; }
    public E first(){ return null; }
    public E last(){ return null; }
    public static <E> SynchronizedSortedBag<E> synchronizedSortedBag(SortedBag<E> p0){ return null; }
}
