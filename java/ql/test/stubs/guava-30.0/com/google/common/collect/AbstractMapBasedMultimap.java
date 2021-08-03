// Generated automatically from com.google.common.collect.AbstractMapBasedMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractMultimap;
import java.io.Serializable;
import java.util.AbstractCollection;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Spliterator;
import java.util.function.BiConsumer;

abstract class AbstractMapBasedMultimap<K, V> extends AbstractMultimap<K, V> implements Serializable
{
    protected AbstractMapBasedMultimap() {}
    protected AbstractMapBasedMultimap(Map<K, Collection<V>> p0){}
    public Collection<Map.Entry<K, V>> entries(){ return null; }
    public Collection<V> get(K p0){ return null; }
    public Collection<V> removeAll(Object p0){ return null; }
    public Collection<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public Collection<V> values(){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean put(K p0, V p1){ return false; }
    public int size(){ return 0; }
    public void clear(){}
    public void forEach(BiConsumer<? super K, ? super V> p0){}
}
