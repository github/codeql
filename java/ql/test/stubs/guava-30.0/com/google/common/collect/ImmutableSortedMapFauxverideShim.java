// Generated automatically from com.google.common.collect.ImmutableSortedMapFauxverideShim for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSortedMap;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.stream.Collector;

abstract class ImmutableSortedMapFauxverideShim<K, V> extends ImmutableMap<K, V>
{
    public static <K, V> ImmutableSortedMap.Builder<K, V> builder(){ return null; }
    public static <K, V> ImmutableSortedMap.Builder<K, V> builderWithExpectedSize(int p0){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> of(K p0, V p1){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> of(K p0, V p1, K p2, V p3){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7, K p8, V p9){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableMap<K, V>> toImmutableMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableMap<K, V>> toImmutableMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1, BinaryOperator<V> p2){ return null; }
}
