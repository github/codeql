// Generated automatically from com.google.common.collect.ImmutableBiMapFauxverideShim for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableMap;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.stream.Collector;

abstract class ImmutableBiMapFauxverideShim<K, V> extends ImmutableMap<K, V>
{
    public static <T, K, V> Collector<T, ? extends Object, ImmutableMap<K, V>> toImmutableMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableMap<K, V>> toImmutableMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1, BinaryOperator<V> p2){ return null; }
}
