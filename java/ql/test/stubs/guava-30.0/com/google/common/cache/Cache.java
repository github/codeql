// Generated automatically from com.google.common.cache.Cache for testing purposes

package com.google.common.cache;

import com.google.common.cache.CacheStats;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentMap;

public interface Cache<K, V>
{
    CacheStats stats();
    ConcurrentMap<K, V> asMap();
    ImmutableMap<K, V> getAllPresent(Iterable<? extends Object> p0);
    V get(K p0, Callable<? extends V> p1);
    V getIfPresent(Object p0);
    long size();
    void cleanUp();
    void invalidate(Object p0);
    void invalidateAll();
    void invalidateAll(Iterable<? extends Object> p0);
    void put(K p0, V p1);
    void putAll(Map<? extends K, ? extends V> p0);
}
