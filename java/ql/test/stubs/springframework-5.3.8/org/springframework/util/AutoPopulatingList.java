// Generated automatically from org.springframework.util.AutoPopulatingList for testing purposes

package org.springframework.util;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

public class AutoPopulatingList<E> implements List<E>, Serializable
{
    protected AutoPopulatingList() {}
    public <T> T[] toArray(T[] p0){ return null; }
    public AutoPopulatingList(AutoPopulatingList.ElementFactory<E> p0){}
    public AutoPopulatingList(Class<? extends E> p0){}
    public AutoPopulatingList(List<E> p0, AutoPopulatingList.ElementFactory<E> p1){}
    public AutoPopulatingList(List<E> p0, Class<? extends E> p1){}
    public E get(int p0){ return null; }
    public E remove(int p0){ return null; }
    public E set(int p0, E p1){ return null; }
    public Iterator<E> iterator(){ return null; }
    public List<E> subList(int p0, int p1){ return null; }
    public ListIterator<E> listIterator(){ return null; }
    public ListIterator<E> listIterator(int p0){ return null; }
    public Object[] toArray(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean addAll(int p0, Collection<? extends E> p1){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int hashCode(){ return 0; }
    public int indexOf(Object p0){ return 0; }
    public int lastIndexOf(Object p0){ return 0; }
    public int size(){ return 0; }
    public void add(int p0, E p1){}
    public void clear(){}
    static public class ElementInstantiationException extends RuntimeException
    {
        protected ElementInstantiationException() {}
        public ElementInstantiationException(String p0){}
        public ElementInstantiationException(String p0, Throwable p1){}
    }
    static public interface ElementFactory<E>
    {
        E createElement(int p0);
    }
}
