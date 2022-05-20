// Generated automatically from com.google.common.collect.AbstractListMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractMapBasedMultimap;
import com.google.common.collect.ListMultimap;
import java.util.Collection;
import java.util.List;
import java.util.Map;

abstract class AbstractListMultimap<K, V> extends AbstractMapBasedMultimap<K, V> implements ListMultimap<K, V>
{
    protected AbstractListMultimap() {}
    protected AbstractListMultimap(Map<K, Collection<V>> p0){}
    public List<V> get(K p0){ return null; }
    public List<V> removeAll(Object p0){ return null; }
    public List<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public Map<K, Collection<V>> asMap(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean put(K p0, V p1){ return false; }
}
