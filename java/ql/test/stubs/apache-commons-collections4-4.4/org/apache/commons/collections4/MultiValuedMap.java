// Generated automatically from org.apache.commons.collections4.MultiValuedMap for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.MultiSet;

public interface MultiValuedMap<K, V>
{
    Collection<Map.Entry<K, V>> entries();
    Collection<V> get(K p0);
    Collection<V> remove(Object p0);
    Collection<V> values();
    Map<K, Collection<V>> asMap();
    MapIterator<K, V> mapIterator();
    MultiSet<K> keys();
    Set<K> keySet();
    boolean containsKey(Object p0);
    boolean containsMapping(Object p0, Object p1);
    boolean containsValue(Object p0);
    boolean isEmpty();
    boolean put(K p0, V p1);
    boolean putAll(K p0, Iterable<? extends V> p1);
    boolean putAll(Map<? extends K, ? extends V> p0);
    boolean putAll(MultiValuedMap<? extends K, ? extends V> p0);
    boolean removeMapping(Object p0, Object p1);
    int size();
    void clear();
}
