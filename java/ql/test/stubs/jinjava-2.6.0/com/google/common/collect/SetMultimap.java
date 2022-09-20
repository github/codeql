// Generated automatically from com.google.common.collect.SetMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.Multimap;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

public interface SetMultimap<K, V> extends Multimap<K, V>
{
    Map<K, Collection<V>> asMap();
    Set<Map.Entry<K, V>> entries();
    Set<V> get(K p0);
    Set<V> removeAll(Object p0);
    Set<V> replaceValues(K p0, Iterable<? extends V> p1);
    boolean equals(Object p0);
}
