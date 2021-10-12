// Generated automatically from com.google.common.collect.ImmutableSortedMap for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.ImmutableSortedMapFauxverideShim;
import com.google.common.collect.ImmutableSortedSet;
import java.util.Comparator;
import java.util.Map;
import java.util.NavigableMap;
import java.util.SortedMap;
import java.util.function.BiConsumer;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.stream.Collector;

public class ImmutableSortedMap<K, V> extends ImmutableSortedMapFauxverideShim<K, V> implements NavigableMap<K, V>
{
    protected ImmutableSortedMap() {}
    public Comparator<? super K> comparator(){ return null; }
    public ImmutableCollection<V> values(){ return null; }
    public ImmutableSet<Map.Entry<K, V>> entrySet(){ return null; }
    public ImmutableSortedMap<K, V> descendingMap(){ return null; }
    public ImmutableSortedMap<K, V> headMap(K p0){ return null; }
    public ImmutableSortedMap<K, V> headMap(K p0, boolean p1){ return null; }
    public ImmutableSortedMap<K, V> subMap(K p0, K p1){ return null; }
    public ImmutableSortedMap<K, V> subMap(K p0, boolean p1, K p2, boolean p3){ return null; }
    public ImmutableSortedMap<K, V> tailMap(K p0){ return null; }
    public ImmutableSortedMap<K, V> tailMap(K p0, boolean p1){ return null; }
    public ImmutableSortedSet<K> descendingKeySet(){ return null; }
    public ImmutableSortedSet<K> keySet(){ return null; }
    public ImmutableSortedSet<K> navigableKeySet(){ return null; }
    public K ceilingKey(K p0){ return null; }
    public K firstKey(){ return null; }
    public K floorKey(K p0){ return null; }
    public K higherKey(K p0){ return null; }
    public K lastKey(){ return null; }
    public K lowerKey(K p0){ return null; }
    public Map.Entry<K, V> ceilingEntry(K p0){ return null; }
    public Map.Entry<K, V> firstEntry(){ return null; }
    public Map.Entry<K, V> floorEntry(K p0){ return null; }
    public Map.Entry<K, V> higherEntry(K p0){ return null; }
    public Map.Entry<K, V> lastEntry(){ return null; }
    public Map.Entry<K, V> lowerEntry(K p0){ return null; }
    public V get(Object p0){ return null; }
    public final Map.Entry<K, V> pollFirstEntry(){ return null; }
    public final Map.Entry<K, V> pollLastEntry(){ return null; }
    public int size(){ return 0; }
    public static <K extends Comparable<? extends Object>, V> ImmutableSortedMap.Builder<K, V> naturalOrder(){ return null; }
    public static <K extends Comparable<? extends Object>, V> ImmutableSortedMap.Builder<K, V> reverseOrder(){ return null; }
    public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(K p0, V p1){ return null; }
    public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(K p0, V p1, K p2, V p3){ return null; }
    public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5){ return null; }
    public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7){ return null; }
    public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7, K p8, V p9){ return null; }
    public static <K, V> ImmutableSortedMap.Builder<K, V> orderedBy(Comparator<K> p0){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> copyOf(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> copyOf(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0, Comparator<? super K> p1){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> copyOf(Map<? extends K, ? extends V> p0){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> copyOf(Map<? extends K, ? extends V> p0, Comparator<? super K> p1){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> copyOfSorted(SortedMap<K, ? extends V> p0){ return null; }
    public static <K, V> ImmutableSortedMap<K, V> of(){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableSortedMap<K, V>> toImmutableSortedMap(Comparator<? super K> p0, Function<? super T, ? extends K> p1, Function<? super T, ? extends V> p2){ return null; }
    public static <T, K, V> Collector<T, ? extends Object, ImmutableSortedMap<K, V>> toImmutableSortedMap(Comparator<? super K> p0, Function<? super T, ? extends K> p1, Function<? super T, ? extends V> p2, BinaryOperator<V> p3){ return null; }
    public void forEach(BiConsumer<? super K, ? super V> p0){}
    static public class Builder<K, V> extends ImmutableMap.Builder<K, V>
    {
        protected Builder() {}
        public Builder(Comparator<? super K> p0){}
        public ImmutableSortedMap.Builder<K, V> put(K p0, V p1){ return null; }
        public ImmutableSortedMap.Builder<K, V> put(Map.Entry<? extends K, ? extends V> p0){ return null; }
        public ImmutableSortedMap.Builder<K, V> putAll(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
        public ImmutableSortedMap.Builder<K, V> putAll(Map<? extends K, ? extends V> p0){ return null; }
        public ImmutableSortedMap<K, V> build(){ return null; }
        public final ImmutableSortedMap.Builder<K, V> orderEntriesByValue(Comparator<? super V> p0){ return null; }
    }
}
