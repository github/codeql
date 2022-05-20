// Generated automatically from com.google.common.collect.MapDifference for testing purposes

package com.google.common.collect;

import java.util.Map;

public interface MapDifference<K, V>
{
    Map<K, MapDifference.ValueDifference<V>> entriesDiffering();
    Map<K, V> entriesInCommon();
    Map<K, V> entriesOnlyOnLeft();
    Map<K, V> entriesOnlyOnRight();
    boolean areEqual();
    boolean equals(Object p0);
    int hashCode();
    static public interface ValueDifference<V>
    {
        V leftValue();
        V rightValue();
        boolean equals(Object p0);
        int hashCode();
    }
}
