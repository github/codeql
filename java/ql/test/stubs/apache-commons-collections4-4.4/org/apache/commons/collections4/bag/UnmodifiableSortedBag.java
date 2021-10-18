// Generated automatically from org.apache.commons.collections4.bag.UnmodifiableSortedBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.function.Predicate;
import org.apache.commons.collections4.SortedBag;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.bag.AbstractSortedBagDecorator;

public class UnmodifiableSortedBag<E> extends AbstractSortedBagDecorator<E> implements Unmodifiable
{
    protected UnmodifiableSortedBag() {}
    public Iterator<E> iterator(){ return null; }
    public Set<E> uniqueSet(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean add(E p0, int p1){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean remove(Object p0, int p1){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <E> SortedBag<E> unmodifiableSortedBag(SortedBag<E> p0){ return null; }
    public void clear(){}
}
