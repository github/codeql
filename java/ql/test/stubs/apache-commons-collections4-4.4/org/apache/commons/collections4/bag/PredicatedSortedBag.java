// Generated automatically from org.apache.commons.collections4.bag.PredicatedSortedBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Comparator;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.SortedBag;
import org.apache.commons.collections4.bag.PredicatedBag;

public class PredicatedSortedBag<E> extends PredicatedBag<E> implements SortedBag<E>
{
    protected PredicatedSortedBag() {}
    protected PredicatedSortedBag(SortedBag<E> p0, Predicate<? super E> p1){}
    protected SortedBag<E> decorated(){ return null; }
    public Comparator<? super E> comparator(){ return null; }
    public E first(){ return null; }
    public E last(){ return null; }
    public static <E> PredicatedSortedBag<E> predicatedSortedBag(SortedBag<E> p0, Predicate<? super E> p1){ return null; }
}
