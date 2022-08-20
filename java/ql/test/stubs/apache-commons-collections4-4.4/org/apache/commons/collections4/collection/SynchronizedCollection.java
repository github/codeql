// Generated automatically from org.apache.commons.collections4.collection.SynchronizedCollection for testing purposes

package org.apache.commons.collections4.collection;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.function.Predicate;

public class SynchronizedCollection<E> implements Collection<E>, Serializable
{
    protected SynchronizedCollection() {}
    protected Collection<E> decorated(){ return null; }
    protected SynchronizedCollection(Collection<E> p0){}
    protected SynchronizedCollection(Collection<E> p0, Object p1){}
    protected final Object lock = null;
    public <T> T[] toArray(T[] p0){ return null; }
    public Iterator<E> iterator(){ return null; }
    public Object[] toArray(){ return null; }
    public String toString(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public static <T> SynchronizedCollection<T> synchronizedCollection(Collection<T> p0){ return null; }
    public void clear(){}
}
