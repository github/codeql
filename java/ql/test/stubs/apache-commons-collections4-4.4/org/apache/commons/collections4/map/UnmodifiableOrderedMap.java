// Generated automatically from org.apache.commons.collections4.map.UnmodifiableOrderedMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.OrderedMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.map.AbstractOrderedMapDecorator;

public class UnmodifiableOrderedMap<K, V> extends AbstractOrderedMapDecorator<K, V> implements Serializable, Unmodifiable
{
    protected UnmodifiableOrderedMap() {}
    public Collection<V> values(){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public static <K, V> OrderedMap<K, V> unmodifiableOrderedMap(OrderedMap<? extends K, ? extends V> p0){ return null; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
