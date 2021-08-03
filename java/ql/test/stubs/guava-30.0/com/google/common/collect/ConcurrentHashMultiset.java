// Generated automatically from com.google.common.collect.ConcurrentHashMultiset for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractMultiset;
import com.google.common.collect.Multiset;
import java.io.Serializable;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.atomic.AtomicInteger;

public class ConcurrentHashMultiset<E> extends AbstractMultiset<E> implements Serializable
{
    protected ConcurrentHashMultiset() {}
    public <T> T[] toArray(T[] p0){ return null; }
    public Iterator<E> iterator(){ return null; }
    public Object[] toArray(){ return null; }
    public Set<Multiset.Entry<E>> createEntrySet(){ return null; }
    public boolean isEmpty(){ return false; }
    public boolean removeExactly(Object p0, int p1){ return false; }
    public boolean setCount(E p0, int p1, int p2){ return false; }
    public int add(E p0, int p1){ return 0; }
    public int count(Object p0){ return 0; }
    public int remove(Object p0, int p1){ return 0; }
    public int setCount(E p0, int p1){ return 0; }
    public int size(){ return 0; }
    public static <E> ConcurrentHashMultiset<E> create(){ return null; }
    public static <E> ConcurrentHashMultiset<E> create(ConcurrentMap<E, AtomicInteger> p0){ return null; }
    public static <E> ConcurrentHashMultiset<E> create(Iterable<? extends E> p0){ return null; }
    public void clear(){}
}
