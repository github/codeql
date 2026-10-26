// Generated automatically from org.apache.commons.collections4.list.TransformedList for testing purposes

package org.apache.commons.collections4.list;

import java.util.Collection;
import java.util.List;
import java.util.ListIterator;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.collection.TransformedCollection;

public class TransformedList<E> extends TransformedCollection<E> implements List<E>
{
    protected TransformedList() {}
    protected List<E> getList(){ return null; }
    protected TransformedList(List<E> p0, Transformer<? super E, ? extends E> p1){}
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
    public static <E> TransformedList<E> transformedList(List<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> TransformedList<E> transformingList(List<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public void add(int p0, E p1){}
}
