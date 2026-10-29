// Generated automatically from org.apache.commons.collections4.multiset.AbstractMultiSet for testing purposes

package org.apache.commons.collections4.multiset;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.AbstractCollection;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import org.apache.commons.collections4.MultiSet;

abstract public class AbstractMultiSet<E> extends AbstractCollection<E> implements MultiSet<E>
{
    protected AbstractMultiSet(){}
    protected Iterator<E> createUniqueSetIterator(){ return null; }
    protected Set<E> createUniqueSet(){ return null; }
    protected Set<MultiSet.Entry<E>> createEntrySet(){ return null; }
    protected abstract Iterator<MultiSet.Entry<E>> createEntrySetIterator();
    protected abstract int uniqueElements();
    protected void doReadObject(ObjectInputStream p0){}
    protected void doWriteObject(ObjectOutputStream p0){}
    public Iterator<E> iterator(){ return null; }
    public Set<E> uniqueSet(){ return null; }
    public Set<MultiSet.Entry<E>> entrySet(){ return null; }
    public String toString(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public int add(E p0, int p1){ return 0; }
    public int getCount(Object p0){ return 0; }
    public int hashCode(){ return 0; }
    public int remove(Object p0, int p1){ return 0; }
    public int setCount(E p0, int p1){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
}
