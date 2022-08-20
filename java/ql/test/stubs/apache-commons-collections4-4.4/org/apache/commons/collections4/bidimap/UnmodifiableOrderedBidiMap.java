// Generated automatically from org.apache.commons.collections4.bidimap.UnmodifiableOrderedBidiMap for testing purposes

package org.apache.commons.collections4.bidimap;

import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.OrderedBidiMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.bidimap.AbstractOrderedBidiMapDecorator;

public class UnmodifiableOrderedBidiMap<K, V> extends AbstractOrderedBidiMapDecorator<K, V> implements Unmodifiable
{
    protected UnmodifiableOrderedBidiMap() {}
    public K removeValue(Object p0){ return null; }
    public OrderedBidiMap<V, K> inverseBidiMap(){ return null; }
    public OrderedBidiMap<V, K> inverseOrderedBidiMap(){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public Set<V> values(){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public static <K, V> OrderedBidiMap<K, V> unmodifiableOrderedBidiMap(OrderedBidiMap<? extends K, ? extends V> p0){ return null; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
