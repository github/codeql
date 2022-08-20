// Generated automatically from org.apache.commons.collections4.map.CompositeMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.map.AbstractIterableMap;

public class CompositeMap<K, V> extends AbstractIterableMap<K, V> implements Serializable
{
    public Collection<V> values(){ return null; }
    public CompositeMap(){}
    public CompositeMap(Map<K, V> p0, Map<K, V> p1){}
    public CompositeMap(Map<K, V> p0, Map<K, V> p1, CompositeMap.MapMutator<K, V> p2){}
    public CompositeMap(Map<K, V>... p0){}
    public CompositeMap(Map<K, V>[] p0, CompositeMap.MapMutator<K, V> p1){}
    public Map<K, V> removeComposited(Map<K, V> p0){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public void addComposited(Map<K, V> p0){}
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
    public void setMutator(CompositeMap.MapMutator<K, V> p0){}
    static public interface MapMutator<K, V> extends Serializable
    {
        V put(CompositeMap<K, V> p0, Map<K, V>[] p1, K p2, V p3);
        void putAll(CompositeMap<K, V> p0, Map<K, V>[] p1, Map<? extends K, ? extends V> p2);
        void resolveCollision(CompositeMap<K, V> p0, Map<K, V> p1, Map<K, V> p2, Collection<K> p3);
    }
}
