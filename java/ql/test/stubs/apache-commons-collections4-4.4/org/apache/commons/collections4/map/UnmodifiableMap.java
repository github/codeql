// Generated automatically from org.apache.commons.collections4.map.UnmodifiableMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.map.AbstractMapDecorator;

public class UnmodifiableMap<K, V> extends AbstractMapDecorator<K, V> implements Serializable, Unmodifiable
{
    protected UnmodifiableMap() {}
    public Collection<V> values(){ return null; }
    public MapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public static <K, V> Map<K, V> unmodifiableMap(Map<? extends K, ? extends V> p0){ return null; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
