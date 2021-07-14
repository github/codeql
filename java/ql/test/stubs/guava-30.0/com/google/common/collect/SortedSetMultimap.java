// Generated automatically from com.google.common.collect.SortedSetMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.SetMultimap;
import java.util.Collection;
import java.util.Comparator;
import java.util.Map;
import java.util.SortedSet;

public interface SortedSetMultimap<K, V> extends SetMultimap<K, V>
{
    Comparator<? super V> valueComparator();
    Map<K, Collection<V>> asMap();
    SortedSet<V> get(K p0);
    SortedSet<V> removeAll(Object p0);
    SortedSet<V> replaceValues(K p0, Iterable<? extends V> p1);
}
