// Generated automatically from org.springframework.util.MultiValueMap for testing purposes

package org.springframework.util;

import java.util.List;
import java.util.Map;

public interface MultiValueMap<K, V> extends Map<K, List<V>>
{
    Map<K, V> toSingleValueMap();
    V getFirst(K p0);
    default void addIfAbsent(K p0, V p1){}
    void add(K p0, V p1);
    void addAll(K p0, List<? extends V> p1);
    void addAll(MultiValueMap<K, V> p0);
    void set(K p0, V p1);
    void setAll(Map<K, V> p0);
}
