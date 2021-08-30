// Generated automatically from com.google.common.collect.ImmutableMap for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.ImmutableSetMultimap;
import java.io.Serializable;
import java.util.Comparator;
import java.util.Map;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.stream.Collector;

abstract public class ImmutableMap<K, V> implements Map<K, V>, Serializable
{
    public ImmutableCollection<V> values(){ return null; }
    public ImmutableSet<K> keySet(){ return null; }
    public ImmutableSet<Map.Entry<K, V>> entrySet(){ return null; }
    public ImmutableSetMultimap<K, V> asMultimap(){ return null; }
    public String toString(){ return null; }
    public abstract V get(Object p0);
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public final V compute(K p0, BiFunction<? super K, ? super V, ? extends V> p1){ return null; }
    public final V computeIfAbsent(K p0, Function<? super K, ? extends V> p1){ return null; }
    public final V computeIfPresent(K p0, BiFunction<? super K, ? super V, ? extends V> p1){ return null; }
    public final V getOrDefault(Object p0, V p1){ return null; }
    public final V merge(K p0, V p1, BiFunction<? super V, ? super V, ? extends V> p2){ return null; }
    public final V put(K p0, V p1){ return null; }
    public final V putIfAbsent(K p0, V p1){ return null; }
    public final V remove(Object p0){ return null; }
    public final V replace(K p0, V p1){ return null; }
    public final boolean remove(Object p0, Object p1){ return false; }
    public final boolean replace(K p0, V p1, V p2){ return false; }
    public final void clear(){}
    public final void putAll(Map<? extends K, ? extends V> p0){}
    public final void replaceAll(BiFunction<? super K, ? super V, ? extends V> p0){}
    public int hashCode(){ return 0; }
    public static <K, V> ImmutableMap.Builder<K, V> builder(){ return null; }
    public static <K, V> ImmutableMap.Builder<K, V> builderWithExpectedSize(int p0){ return null; }
    public static <K, V> ImmutableMap<K, V> copyOf(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
    public static <K, V> ImmutableMap<K, V> copyOf(Map<? extends K, ? extends V> p0){ return null; }
    public static <K, V> ImmutableMap<K, V> of(){ return null; }
    public static <K, V> ImmutableMap<K, V> of(K p0, V p1){ return null; }
    public static <K, V> ImmutableMap<K, V> of(K p0, V p1, K p2, V p3){ return null; }
    public static <K, V> ImmutableMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5){ return null; }
    public static <K, V> ImmutableMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7){ return null; }
    public static <K, V> ImmutableMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7, K p8, V p9){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableMap<K, V>> toImmutableMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableMap<K, V>> toImmutableMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1, BinaryOperator<V> p2){ return null; }
    static public class Builder<K, V>
    {
        public Builder(){}
        public ImmutableMap.Builder<K, V> orderEntriesByValue(Comparator<? super V> p0){ return null; }
        public ImmutableMap.Builder<K, V> put(K p0, V p1){ return null; }
        public ImmutableMap.Builder<K, V> put(Map.Entry<? extends K, ? extends V> p0){ return null; }
        public ImmutableMap.Builder<K, V> putAll(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
        public ImmutableMap.Builder<K, V> putAll(Map<? extends K, ? extends V> p0){ return null; }
        public ImmutableMap<K, V> build(){ return null; }
    }
}
