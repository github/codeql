// Generated automatically from com.google.common.cache.CacheLoader for testing purposes

package com.google.common.cache;

import com.google.common.base.Function;
import com.google.common.base.Supplier;
import com.google.common.util.concurrent.ListenableFuture;
import java.util.Map;
import java.util.concurrent.Executor;

abstract public class CacheLoader<K, V>
{
    protected CacheLoader(){}
    public ListenableFuture<V> reload(K p0, V p1){ return null; }
    public Map<K, V> loadAll(Iterable<? extends K> p0){ return null; }
    public abstract V load(K p0);
    public static <K, V> CacheLoader<K, V> asyncReloading(CacheLoader<K, V> p0, Executor p1){ return null; }
    public static <K, V> CacheLoader<K, V> from(Function<K, V> p0){ return null; }
    public static <V> CacheLoader<Object, V> from(Supplier<V> p0){ return null; }
}
