// Generated automatically from com.google.common.cache.LoadingCache for testing purposes

package com.google.common.cache;

import com.google.common.base.Function;
import com.google.common.cache.Cache;
import com.google.common.collect.ImmutableMap;
import java.util.concurrent.ConcurrentMap;

public interface LoadingCache<K, V> extends Cache<K, V>, Function<K, V>
{
    ConcurrentMap<K, V> asMap();
    ImmutableMap<K, V> getAll(Iterable<? extends K> p0);
    V apply(K p0);
    V get(K p0);
    V getUnchecked(K p0);
    void refresh(K p0);
}
