// Generated automatically from com.google.common.collect.BiMap for testing purposes

package com.google.common.collect;

import java.util.Map;
import java.util.Set;

public interface BiMap<K, V> extends Map<K, V>
{
    BiMap<V, K> inverse();
    Set<V> values();
    V forcePut(K p0, V p1);
    V put(K p0, V p1);
    void putAll(Map<? extends K, ? extends V> p0);
}
