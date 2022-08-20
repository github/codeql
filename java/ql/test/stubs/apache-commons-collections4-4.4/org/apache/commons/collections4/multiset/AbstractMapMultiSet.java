// Generated automatically from org.apache.commons.collections4.multiset.AbstractMapMultiSet for testing purposes

package org.apache.commons.collections4.multiset;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Iterator;
import java.util.Map;
import org.apache.commons.collections4.MultiSet;
import org.apache.commons.collections4.multiset.AbstractMultiSet;

abstract public class AbstractMapMultiSet<E> extends AbstractMultiSet<E>
{
    protected AbstractMapMultiSet(){}
    protected AbstractMapMultiSet(Map<E, AbstractMapMultiSet.MutableInteger> p0){}
    protected Iterator<E> createUniqueSetIterator(){ return null; }
    protected Iterator<MultiSet.Entry<E>> createEntrySetIterator(){ return null; }
    protected Map<E, AbstractMapMultiSet.MutableInteger> getMap(){ return null; }
    protected int uniqueElements(){ return 0; }
    protected void doReadObject(ObjectInputStream p0){}
    protected void doWriteObject(ObjectOutputStream p0){}
    protected void setMap(Map<E, AbstractMapMultiSet.MutableInteger> p0){}
    public <T> T[] toArray(T[] p0){ return null; }
    public Iterator<E> iterator(){ return null; }
    public Object[] toArray(){ return null; }
    public boolean contains(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int add(E p0, int p1){ return 0; }
    public int getCount(Object p0){ return 0; }
    public int hashCode(){ return 0; }
    public int remove(Object p0, int p1){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
    static class MutableInteger
    {
        protected MutableInteger() {}
        MutableInteger(int p0){}
        protected int value = 0;
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
    }
}
