// Generated automatically from com.google.common.collect.ImmutableListMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMultimap;
import com.google.common.collect.ListMultimap;
import com.google.common.collect.Multimap;
import java.util.Comparator;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collector;
import java.util.stream.Stream;

public class ImmutableListMultimap<K, V> extends ImmutableMultimap<K, V> implements ListMultimap<K, V>
{
    protected ImmutableListMultimap() {}
    public ImmutableList<V> get(K p0){ return null; }
    public ImmutableListMultimap<V, K> inverse(){ return null; }
    public final ImmutableList<V> removeAll(Object p0){ return null; }
    public final ImmutableList<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public static <K, V> ImmutableListMultimap.Builder<K, V> builder(){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> copyOf(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> copyOf(Multimap<? extends K, ? extends V> p0){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> of(){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> of(K p0, V p1){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> of(K p0, V p1, K p2, V p3){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7, K p8, V p9){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableListMultimap<K, V>> flatteningToImmutableListMultimap(Function<? super T, ? extends K> p0, Function<? super T, ? extends Stream<? extends V>> p1){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableListMultimap<K, V>> toImmutableListMultimap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1){ return null; }
    static public class Builder<K, V> extends ImmutableMultimap.Builder<K, V>
    {
        public Builder(){}
        public ImmutableListMultimap.Builder<K, V> orderKeysBy(Comparator<? super K> p0){ return null; }
        public ImmutableListMultimap.Builder<K, V> orderValuesBy(Comparator<? super V> p0){ return null; }
        public ImmutableListMultimap.Builder<K, V> put(K p0, V p1){ return null; }
        public ImmutableListMultimap.Builder<K, V> put(Map.Entry<? extends K, ? extends V> p0){ return null; }
        public ImmutableListMultimap.Builder<K, V> putAll(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
        public ImmutableListMultimap.Builder<K, V> putAll(K p0, Iterable<? extends V> p1){ return null; }
        public ImmutableListMultimap.Builder<K, V> putAll(K p0, V... p1){ return null; }
        public ImmutableListMultimap.Builder<K, V> putAll(Multimap<? extends K, ? extends V> p0){ return null; }
        public ImmutableListMultimap<K, V> build(){ return null; }
    }
}
