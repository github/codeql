// Generated automatically from org.apache.commons.collections4.iterators.CollatingIterator for testing purposes

package org.apache.commons.collections4.iterators;

import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

public class CollatingIterator<E> implements Iterator<E>
{
    public CollatingIterator(){}
    public CollatingIterator(Comparator<? super E> p0){}
    public CollatingIterator(Comparator<? super E> p0, Collection<Iterator<? extends E>> p1){}
    public CollatingIterator(Comparator<? super E> p0, Iterator<? extends E> p1, Iterator<? extends E> p2){}
    public CollatingIterator(Comparator<? super E> p0, Iterator<? extends E>[] p1){}
    public CollatingIterator(Comparator<? super E> p0, int p1){}
    public Comparator<? super E> getComparator(){ return null; }
    public E next(){ return null; }
    public List<Iterator<? extends E>> getIterators(){ return null; }
    public boolean hasNext(){ return false; }
    public int getIteratorIndex(){ return 0; }
    public void addIterator(Iterator<? extends E> p0){}
    public void remove(){}
    public void setComparator(Comparator<? super E> p0){}
    public void setIterator(int p0, Iterator<? extends E> p1){}
}
