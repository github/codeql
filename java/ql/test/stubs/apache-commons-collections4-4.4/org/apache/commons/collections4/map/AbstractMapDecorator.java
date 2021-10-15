// Generated automatically from org.apache.commons.collections4.map.AbstractMapDecorator for testing purposes

package org.apache.commons.collections4.map;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.map.AbstractIterableMap;

abstract public class AbstractMapDecorator<K, V> extends AbstractIterableMap<K, V>
{
    Map<K, V> map = null;
    protected AbstractMapDecorator(){}
    protected AbstractMapDecorator(Map<K, V> p0){}
    protected Map<K, V> decorated(){ return null; }
    public Collection<V> values(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
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
