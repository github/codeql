// Generated automatically from com.google.common.cache.CacheBuilder for testing purposes

package com.google.common.cache;

import com.google.common.base.Ticker;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilderSpec;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.cache.RemovalListener;
import com.google.common.cache.Weigher;
import java.time.Duration;
import java.util.concurrent.TimeUnit;

public class CacheBuilder<K, V>
{
    protected CacheBuilder() {}
    public <K1 extends K, V1 extends V> Cache<K1, V1> build(){ return null; }
    public <K1 extends K, V1 extends V> CacheBuilder<K1, V1> removalListener(RemovalListener<? super K1, ? super V1> p0){ return null; }
    public <K1 extends K, V1 extends V> CacheBuilder<K1, V1> weigher(Weigher<? super K1, ? super V1> p0){ return null; }
    public <K1 extends K, V1 extends V> LoadingCache<K1, V1> build(CacheLoader<? super K1, V1> p0){ return null; }
    public CacheBuilder<K, V> concurrencyLevel(int p0){ return null; }
    public CacheBuilder<K, V> expireAfterAccess(Duration p0){ return null; }
    public CacheBuilder<K, V> expireAfterAccess(long p0, TimeUnit p1){ return null; }
    public CacheBuilder<K, V> expireAfterWrite(Duration p0){ return null; }
    public CacheBuilder<K, V> expireAfterWrite(long p0, TimeUnit p1){ return null; }
    public CacheBuilder<K, V> initialCapacity(int p0){ return null; }
    public CacheBuilder<K, V> maximumSize(long p0){ return null; }
    public CacheBuilder<K, V> maximumWeight(long p0){ return null; }
    public CacheBuilder<K, V> recordStats(){ return null; }
    public CacheBuilder<K, V> refreshAfterWrite(Duration p0){ return null; }
    public CacheBuilder<K, V> refreshAfterWrite(long p0, TimeUnit p1){ return null; }
    public CacheBuilder<K, V> softValues(){ return null; }
    public CacheBuilder<K, V> ticker(Ticker p0){ return null; }
    public CacheBuilder<K, V> weakKeys(){ return null; }
    public CacheBuilder<K, V> weakValues(){ return null; }
    public String toString(){ return null; }
    public static CacheBuilder<Object, Object> from(CacheBuilderSpec p0){ return null; }
    public static CacheBuilder<Object, Object> from(String p0){ return null; }
    public static CacheBuilder<Object, Object> newBuilder(){ return null; }
}
