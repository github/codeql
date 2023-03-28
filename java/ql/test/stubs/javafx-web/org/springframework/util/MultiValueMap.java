// Generated automatically from org.springframework.util.MultiValueMap for testing purposes

package org.springframework.util;

import java.util.List;
import java.util.Map;

public interface MultiValueMap<K, V> extends java.util.Map<K, java.util.List<V>>
{
    V getFirst(K p0);
    default void addIfAbsent(K p0, V p1){}
    java.util.Map<K, V> toSingleValueMap();
    void add(K p0, V p1);
    void addAll(K p0, List<? extends V> p1);
    void addAll(MultiValueMap<K, V> p0);
    void set(K p0, V p1);
    void setAll(java.util.Map<K, V> p0);
}
