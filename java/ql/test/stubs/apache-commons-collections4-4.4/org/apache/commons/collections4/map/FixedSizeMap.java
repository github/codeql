// Generated automatically from org.apache.commons.collections4.map.FixedSizeMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.BoundedMap;
import org.apache.commons.collections4.map.AbstractMapDecorator;

public class FixedSizeMap<K, V> extends AbstractMapDecorator<K, V> implements BoundedMap<K, V>, Serializable
{
    protected FixedSizeMap() {}
    protected FixedSizeMap(Map<K, V> p0){}
    public Collection<V> values(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean isFull(){ return false; }
    public int maxSize(){ return 0; }
    public static <K, V> FixedSizeMap<K, V> fixedSizeMap(Map<K, V> p0){ return null; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
