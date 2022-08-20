// Generated automatically from com.google.common.collect.AbstractMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.Multimap;
import com.google.common.collect.Multiset;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

abstract class AbstractMultimap<K, V> implements Multimap<K, V>
{
    public Collection<Map.Entry<K, V>> entries(){ return null; }
    public Collection<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public Collection<V> values(){ return null; }
    public Map<K, Collection<V>> asMap(){ return null; }
    public Multiset<K> keys(){ return null; }
    public Set<K> keySet(){ return null; }
    public String toString(){ return null; }
    public boolean containsEntry(Object p0, Object p1){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean put(K p0, V p1){ return false; }
    public boolean putAll(K p0, Iterable<? extends V> p1){ return false; }
    public boolean putAll(Multimap<? extends K, ? extends V> p0){ return false; }
    public boolean remove(Object p0, Object p1){ return false; }
    public int hashCode(){ return 0; }
}
