// Generated automatically from com.google.common.collect.AbstractSetMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractMapBasedMultimap;
import com.google.common.collect.SetMultimap;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

abstract class AbstractSetMultimap<K, V> extends AbstractMapBasedMultimap<K, V> implements SetMultimap<K, V>
{
    protected AbstractSetMultimap() {}
    protected AbstractSetMultimap(Map<K, Collection<V>> p0){}
    public Map<K, Collection<V>> asMap(){ return null; }
    public Set<Map.Entry<K, V>> entries(){ return null; }
    public Set<V> get(K p0){ return null; }
    public Set<V> removeAll(Object p0){ return null; }
    public Set<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean put(K p0, V p1){ return false; }
}
