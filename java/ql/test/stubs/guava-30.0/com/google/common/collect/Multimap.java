// Generated automatically from com.google.common.collect.Multimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.Multiset;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.util.function.BiConsumer;

public interface Multimap<K, V>
{
    Collection<Map.Entry<K, V>> entries();
    Collection<V> get(K p0);
    Collection<V> removeAll(Object p0);
    Collection<V> replaceValues(K p0, Iterable<? extends V> p1);
    Collection<V> values();
    Map<K, Collection<V>> asMap();
    Multiset<K> keys();
    Set<K> keySet();
    boolean containsEntry(Object p0, Object p1);
    boolean containsKey(Object p0);
    boolean containsValue(Object p0);
    boolean equals(Object p0);
    boolean isEmpty();
    boolean put(K p0, V p1);
    boolean putAll(K p0, Iterable<? extends V> p1);
    boolean putAll(Multimap<? extends K, ? extends V> p0);
    boolean remove(Object p0, Object p1);
    default void forEach(BiConsumer<? super K, ? super V> p0){}
    int hashCode();
    int size();
    void clear();
}
