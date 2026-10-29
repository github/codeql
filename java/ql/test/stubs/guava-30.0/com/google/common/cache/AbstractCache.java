// Generated automatically from com.google.common.cache.AbstractCache for testing purposes

package com.google.common.cache;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheStats;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentMap;

abstract public class AbstractCache<K, V> implements Cache<K, V>
{
    protected AbstractCache(){}
    public CacheStats stats(){ return null; }
    public ConcurrentMap<K, V> asMap(){ return null; }
    public ImmutableMap<K, V> getAllPresent(Iterable<? extends Object> p0){ return null; }
    public V get(K p0, Callable<? extends V> p1){ return null; }
    public long size(){ return 0; }
    public void cleanUp(){}
    public void invalidate(Object p0){}
    public void invalidateAll(){}
    public void invalidateAll(Iterable<? extends Object> p0){}
    public void put(K p0, V p1){}
    public void putAll(Map<? extends K, ? extends V> p0){}
    static public interface StatsCounter
    {
        CacheStats snapshot();
        void recordEviction();
        void recordHits(int p0);
        void recordLoadException(long p0);
        void recordLoadSuccess(long p0);
        void recordMisses(int p0);
    }
}
