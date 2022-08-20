// Generated automatically from org.apache.commons.collections4.list.FixedSizeList for testing purposes

package org.apache.commons.collections4.list;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.function.Predicate;
import org.apache.commons.collections4.BoundedCollection;
import org.apache.commons.collections4.list.AbstractSerializableListDecorator;

public class FixedSizeList<E> extends AbstractSerializableListDecorator<E> implements BoundedCollection<E>
{
    protected FixedSizeList() {}
    protected FixedSizeList(List<E> p0){}
    public E get(int p0){ return null; }
    public E remove(int p0){ return null; }
    public E set(int p0, E p1){ return null; }
    public Iterator<E> iterator(){ return null; }
    public List<E> subList(int p0, int p1){ return null; }
    public ListIterator<E> listIterator(){ return null; }
    public ListIterator<E> listIterator(int p0){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean addAll(int p0, Collection<? extends E> p1){ return false; }
    public boolean isFull(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int indexOf(Object p0){ return 0; }
    public int lastIndexOf(Object p0){ return 0; }
    public int maxSize(){ return 0; }
    public static <E> FixedSizeList<E> fixedSizeList(List<E> p0){ return null; }
    public void add(int p0, E p1){}
    public void clear(){}
}
