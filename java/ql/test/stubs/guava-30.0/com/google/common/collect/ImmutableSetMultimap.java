// Generated automatically from com.google.common.collect.ImmutableSetMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableMultimap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Multimap;
import com.google.common.collect.SetMultimap;
import java.util.Comparator;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collector;
import java.util.stream.Stream;

public class ImmutableSetMultimap<K, V> extends ImmutableMultimap<K, V> implements SetMultimap<K, V>
{
    protected ImmutableSetMultimap() {}
    public ImmutableSet<Map.Entry<K, V>> entries(){ return null; }
    public ImmutableSet<V> get(K p0){ return null; }
    public ImmutableSetMultimap<V, K> inverse(){ return null; }
    public final ImmutableSet<V> removeAll(Object p0){ return null; }
    public final ImmutableSet<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public static <K, V> ImmutableSetMultimap.Builder<K, V> builder(){ return null; }
    public static <K, V> ImmutableSetMultimap<K, V> copyOf(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
    public static <K, V> ImmutableSetMultimap<K, V> copyOf(Multimap<? extends K, ? extends V> p0){ return null; }
    public static <K, V> ImmutableSetMultimap<K, V> of(){ return null; }
    public static <K, V> ImmutableSetMultimap<K, V> of(K p0, V p1){ return null; }
    public static <K, V> ImmutableSetMultimap<K, V> of(K p0, V p1, K p2, V p3){ return null; }
    public static <K, V> ImmutableSetMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5){ return null; }
    public static <K, V> ImmutableSetMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7){ return null; }
    public static <K, V> ImmutableSetMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7, K p8, V p9){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableSetMultimap<K, V>> flatteningToImmutableSetMultimap(Function<? super T, ? extends K> p0, Function<? super T, ? extends Stream<? extends V>> p1){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableSetMultimap<K, V>> toImmutableSetMultimap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1){ return null; }
    static public class Builder<K, V> extends ImmutableMultimap.Builder<K, V>
    {
        public Builder(){}
        public ImmutableSetMultimap.Builder<K, V> orderKeysBy(Comparator<? super K> p0){ return null; }
        public ImmutableSetMultimap.Builder<K, V> orderValuesBy(Comparator<? super V> p0){ return null; }
        public ImmutableSetMultimap.Builder<K, V> put(K p0, V p1){ return null; }
        public ImmutableSetMultimap.Builder<K, V> put(Map.Entry<? extends K, ? extends V> p0){ return null; }
        public ImmutableSetMultimap.Builder<K, V> putAll(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
        public ImmutableSetMultimap.Builder<K, V> putAll(K p0, Iterable<? extends V> p1){ return null; }
        public ImmutableSetMultimap.Builder<K, V> putAll(K p0, V... p1){ return null; }
        public ImmutableSetMultimap.Builder<K, V> putAll(Multimap<? extends K, ? extends V> p0){ return null; }
        public ImmutableSetMultimap<K, V> build(){ return null; }
    }
}
