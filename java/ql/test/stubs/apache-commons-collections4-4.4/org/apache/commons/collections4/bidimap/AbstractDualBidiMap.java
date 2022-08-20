// Generated automatically from org.apache.commons.collections4.bidimap.AbstractDualBidiMap for testing purposes

package org.apache.commons.collections4.bidimap;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.MapIterator;

abstract public class AbstractDualBidiMap<K, V> implements BidiMap<K, V>
{
    protected AbstractDualBidiMap(){}
    protected AbstractDualBidiMap(Map<K, V> p0, Map<V, K> p1){}
    protected AbstractDualBidiMap(Map<K, V> p0, Map<V, K> p1, BidiMap<V, K> p2){}
    protected Iterator<K> createKeySetIterator(Iterator<K> p0){ return null; }
    protected Iterator<Map.Entry<K, V>> createEntrySetIterator(Iterator<Map.Entry<K, V>> p0){ return null; }
    protected Iterator<V> createValuesIterator(Iterator<V> p0){ return null; }
    protected abstract BidiMap<V, K> createBidiMap(Map<V, K> p0, Map<K, V> p1, BidiMap<K, V> p2);
    public BidiMap<V, K> inverseBidiMap(){ return null; }
    public K getKey(Object p0){ return null; }
    public K removeValue(Object p0){ return null; }
    public MapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public Set<V> values(){ return null; }
    public String toString(){ return null; }
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
