// Generated automatically from com.google.common.collect.AbstractMapBasedMultiset for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractMultiset;
import com.google.common.collect.Count;
import com.google.common.collect.Multiset;
import java.io.Serializable;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.function.ObjIntConsumer;

abstract class AbstractMapBasedMultiset<E> extends AbstractMultiset<E> implements Serializable
{
    protected AbstractMapBasedMultiset() {}
    protected AbstractMapBasedMultiset(Map<E, Count> p0){}
    public Iterator<E> iterator(){ return null; }
    public Set<Multiset.Entry<E>> entrySet(){ return null; }
    public int add(E p0, int p1){ return 0; }
    public int count(Object p0){ return 0; }
    public int remove(Object p0, int p1){ return 0; }
    public int setCount(E p0, int p1){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
    public void forEachEntry(ObjIntConsumer<? super E> p0){}
}
