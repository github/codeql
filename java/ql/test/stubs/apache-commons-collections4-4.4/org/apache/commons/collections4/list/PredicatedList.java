// Generated automatically from org.apache.commons.collections4.list.PredicatedList for testing purposes

package org.apache.commons.collections4.list;

import java.util.Collection;
import java.util.List;
import java.util.ListIterator;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.collection.PredicatedCollection;

public class PredicatedList<E> extends PredicatedCollection<E> implements List<E>
{
    protected PredicatedList() {}
    protected List<E> decorated(){ return null; }
    protected PredicatedList(List<E> p0, Predicate<? super E> p1){}
    public E get(int p0){ return null; }
    public E remove(int p0){ return null; }
    public E set(int p0, E p1){ return null; }
    public List<E> subList(int p0, int p1){ return null; }
    public ListIterator<E> listIterator(){ return null; }
    public ListIterator<E> listIterator(int p0){ return null; }
    public boolean addAll(int p0, Collection<? extends E> p1){ return false; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public int indexOf(Object p0){ return 0; }
    public int lastIndexOf(Object p0){ return 0; }
    public static <T> PredicatedList<T> predicatedList(List<T> p0, Predicate<? super T> p1){ return null; }
    public void add(int p0, E p1){}
}
