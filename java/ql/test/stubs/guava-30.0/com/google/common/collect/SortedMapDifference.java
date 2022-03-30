// Generated automatically from com.google.common.collect.SortedMapDifference for testing purposes

package com.google.common.collect;

import com.google.common.collect.MapDifference;
import java.util.SortedMap;

public interface SortedMapDifference<K, V> extends MapDifference<K, V>
{
    SortedMap<K, MapDifference.ValueDifference<V>> entriesDiffering();
    SortedMap<K, V> entriesInCommon();
    SortedMap<K, V> entriesOnlyOnLeft();
    SortedMap<K, V> entriesOnlyOnRight();
}
