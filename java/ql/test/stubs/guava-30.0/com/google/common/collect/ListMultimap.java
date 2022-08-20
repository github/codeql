// Generated automatically from com.google.common.collect.ListMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.Multimap;
import java.util.Collection;
import java.util.List;
import java.util.Map;

public interface ListMultimap<K, V> extends Multimap<K, V>
{
    List<V> get(K p0);
    List<V> removeAll(Object p0);
    List<V> replaceValues(K p0, Iterable<? extends V> p1);
    Map<K, Collection<V>> asMap();
    boolean equals(Object p0);
}
