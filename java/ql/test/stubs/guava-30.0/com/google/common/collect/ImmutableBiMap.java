// Generated automatically from com.google.common.collect.ImmutableBiMap for testing purposes

package com.google.common.collect;

import com.google.common.collect.BiMap;
import com.google.common.collect.ImmutableBiMapFauxverideShim;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import java.util.Comparator;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collector;

abstract public class ImmutableBiMap<K, V> extends ImmutableBiMapFauxverideShim<K, V> implements BiMap<K, V>
{
    public ImmutableSet<V> values(){ return null; }
    public abstract ImmutableBiMap<V, K> inverse();
    public final V forcePut(K p0, V p1){ return null; }
    public static <K, V> ImmutableBiMap.Builder<K, V> builder(){ return null; }
    public static <K, V> ImmutableBiMap.Builder<K, V> builderWithExpectedSize(int p0){ return null; }
    public static <K, V> ImmutableBiMap<K, V> copyOf(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
    public static <K, V> ImmutableBiMap<K, V> copyOf(Map<? extends K, ? extends V> p0){ return null; }
    public static <K, V> ImmutableBiMap<K, V> of(){ return null; }
    public static <K, V> ImmutableBiMap<K, V> of(K p0, V p1){ return null; }
    public static <K, V> ImmutableBiMap<K, V> of(K p0, V p1, K p2, V p3){ return null; }
    public static <K, V> ImmutableBiMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5){ return null; }
    public static <K, V> ImmutableBiMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7){ return null; }
    public static <K, V> ImmutableBiMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7, K p8, V p9){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableBiMap<K, V>> toImmutableBiMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1){ return null; }
    static public class Builder<K, V> extends ImmutableMap.Builder<K, V>
    {
        public Builder(){}
        public ImmutableBiMap.Builder<K, V> orderEntriesByValue(Comparator<? super V> p0){ return null; }
        public ImmutableBiMap.Builder<K, V> put(K p0, V p1){ return null; }
        public ImmutableBiMap.Builder<K, V> put(Map.Entry<? extends K, ? extends V> p0){ return null; }
        public ImmutableBiMap.Builder<K, V> putAll(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
        public ImmutableBiMap.Builder<K, V> putAll(Map<? extends K, ? extends V> p0){ return null; }
        public ImmutableBiMap<K, V> build(){ return null; }
    }
}
