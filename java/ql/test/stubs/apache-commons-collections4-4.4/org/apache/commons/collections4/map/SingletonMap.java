// Generated automatically from org.apache.commons.collections4.map.SingletonMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.BoundedMap;
import org.apache.commons.collections4.KeyValue;
import org.apache.commons.collections4.OrderedMap;
import org.apache.commons.collections4.OrderedMapIterator;

public class SingletonMap<K, V> implements BoundedMap<K, V>, Cloneable, KeyValue<K, V>, OrderedMap<K, V>, Serializable
{
    protected boolean isEqualKey(Object p0){ return false; }
    protected boolean isEqualValue(Object p0){ return false; }
    public Collection<V> values(){ return null; }
    public K firstKey(){ return null; }
    public K getKey(){ return null; }
    public K lastKey(){ return null; }
    public K nextKey(K p0){ return null; }
    public K previousKey(K p0){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public SingletonMap(){}
    public SingletonMap(K p0, V p1){}
    public SingletonMap(KeyValue<K, V> p0){}
    public SingletonMap(Map.Entry<? extends K, ? extends V> p0){}
    public SingletonMap(Map<? extends K, ? extends V> p0){}
    public SingletonMap<K, V> clone(){ return null; }
    public String toString(){ return null; }
    public V get(Object p0){ return null; }
    public V getValue(){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public V setValue(V p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean isFull(){ return false; }
    public int hashCode(){ return 0; }
    public int maxSize(){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
