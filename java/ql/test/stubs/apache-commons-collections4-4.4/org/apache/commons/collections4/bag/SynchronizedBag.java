// Generated automatically from org.apache.commons.collections4.bag.SynchronizedBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Set;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.collection.SynchronizedCollection;

public class SynchronizedBag<E> extends SynchronizedCollection<E> implements Bag<E>
{
    protected SynchronizedBag() {}
    protected Bag<E> getBag(){ return null; }
    protected SynchronizedBag(Bag<E> p0){}
    protected SynchronizedBag(Bag<E> p0, Object p1){}
    public Set<E> uniqueSet(){ return null; }
    public boolean add(E p0, int p1){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean remove(Object p0, int p1){ return false; }
    public int getCount(Object p0){ return 0; }
    public int hashCode(){ return 0; }
    public static <E> SynchronizedBag<E> synchronizedBag(Bag<E> p0){ return null; }
}
