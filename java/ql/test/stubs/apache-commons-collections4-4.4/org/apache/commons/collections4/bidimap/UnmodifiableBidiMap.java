// Generated automatically from org.apache.commons.collections4.bidimap.UnmodifiableBidiMap for testing purposes

package org.apache.commons.collections4.bidimap;

import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.bidimap.AbstractBidiMapDecorator;

public class UnmodifiableBidiMap<K, V> extends AbstractBidiMapDecorator<K, V> implements Unmodifiable
{
    protected UnmodifiableBidiMap() {}
    public BidiMap<V, K> inverseBidiMap(){ return null; }
    public K removeValue(Object p0){ return null; }
    public MapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public Set<V> values(){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public static <K, V> BidiMap<K, V> unmodifiableBidiMap(BidiMap<? extends K, ? extends V> p0){ return null; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
