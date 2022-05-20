// Generated automatically from org.apache.commons.collections4.list.UnmodifiableList for testing purposes

package org.apache.commons.collections4.list;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.function.Predicate;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.list.AbstractSerializableListDecorator;

public class UnmodifiableList<E> extends AbstractSerializableListDecorator<E> implements Unmodifiable
{
    protected UnmodifiableList() {}
    public E remove(int p0){ return null; }
    public E set(int p0, E p1){ return null; }
    public Iterator<E> iterator(){ return null; }
    public List<E> subList(int p0, int p1){ return null; }
    public ListIterator<E> listIterator(){ return null; }
    public ListIterator<E> listIterator(int p0){ return null; }
    public UnmodifiableList(List<? extends E> p0){}
    public boolean add(Object p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean addAll(int p0, Collection<? extends E> p1){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <E> List<E> unmodifiableList(List<? extends E> p0){ return null; }
    public void add(int p0, E p1){}
    public void clear(){}
}
