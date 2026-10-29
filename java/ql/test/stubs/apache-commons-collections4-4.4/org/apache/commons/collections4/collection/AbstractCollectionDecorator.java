// Generated automatically from org.apache.commons.collections4.collection.AbstractCollectionDecorator for testing purposes

package org.apache.commons.collections4.collection;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.function.Predicate;

abstract public class AbstractCollectionDecorator<E> implements Collection<E>, Serializable
{
    protected AbstractCollectionDecorator(){}
    protected AbstractCollectionDecorator(Collection<E> p0){}
    protected Collection<E> decorated(){ return null; }
    protected void setCollection(Collection<E> p0){}
    public <T> T[] toArray(T[] p0){ return null; }
    public Iterator<E> iterator(){ return null; }
    public Object[] toArray(){ return null; }
    public String toString(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int size(){ return 0; }
    public void clear(){}
}
