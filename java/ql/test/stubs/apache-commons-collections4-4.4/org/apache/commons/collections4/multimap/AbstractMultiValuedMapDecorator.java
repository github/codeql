// Generated automatically from org.apache.commons.collections4.multimap.AbstractMultiValuedMapDecorator for testing purposes

package org.apache.commons.collections4.multimap;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.MultiSet;
import org.apache.commons.collections4.MultiValuedMap;

abstract public class AbstractMultiValuedMapDecorator<K, V> implements MultiValuedMap<K, V>, Serializable
{
    protected AbstractMultiValuedMapDecorator() {}
    protected AbstractMultiValuedMapDecorator(MultiValuedMap<K, V> p0){}
    protected MultiValuedMap<K, V> decorated(){ return null; }
    public Collection<Map.Entry<K, V>> entries(){ return null; }
    public Collection<V> get(K p0){ return null; }
    public Collection<V> remove(Object p0){ return null; }
    public Collection<V> values(){ return null; }
    public Map<K, Collection<V>> asMap(){ return null; }
    public MapIterator<K, V> mapIterator(){ return null; }
    public MultiSet<K> keys(){ return null; }
    public Set<K> keySet(){ return null; }
    public String toString(){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsMapping(Object p0, Object p1){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean put(K p0, V p1){ return false; }
    public boolean putAll(K p0, Iterable<? extends V> p1){ return false; }
    public boolean putAll(Map<? extends K, ? extends V> p0){ return false; }
    public boolean putAll(MultiValuedMap<? extends K, ? extends V> p0){ return false; }
    public boolean removeMapping(Object p0, Object p1){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
}
