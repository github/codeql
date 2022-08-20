// Generated automatically from org.apache.commons.collections4.bag.AbstractMapBag for testing purposes

package org.apache.commons.collections4.bag;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.Bag;

abstract public class AbstractMapBag<E> implements Bag<E>
{
    boolean containsAll(Bag<? extends Object> p0){ return false; }
    boolean retainAll(Bag<? extends Object> p0){ return false; }
    protected AbstractMapBag(){}
    protected AbstractMapBag(Map<E, AbstractMapBag.MutableInteger> p0){}
    protected Map<E, AbstractMapBag.MutableInteger> getMap(){ return null; }
    protected void doReadObject(Map<E, AbstractMapBag.MutableInteger> p0, ObjectInputStream p1){}
    protected void doWriteObject(ObjectOutputStream p0){}
    public <T> T[] toArray(T[] p0){ return null; }
    public Iterator<E> iterator(){ return null; }
    public Object[] toArray(){ return null; }
    public Set<E> uniqueSet(){ return null; }
    public String toString(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean add(E p0, int p1){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean remove(Object p0, int p1){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int getCount(Object p0){ return 0; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
    protected static class MutableInteger
    {
        protected MutableInteger() {}
        MutableInteger(int p0){}
        protected int value = 0;
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
    }
}
