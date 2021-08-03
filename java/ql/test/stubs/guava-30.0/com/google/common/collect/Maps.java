// Generated automatically from com.google.common.collect.Maps for testing purposes, and adjusted manually

package com.google.common.collect;

import com.google.common.base.Converter;
import com.google.common.base.Equivalence;
import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.collect.BiMap;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.MapDifference;
import com.google.common.collect.Range;
import com.google.common.collect.SortedMapDifference;
import java.util.AbstractMap;
import java.util.Comparator;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.IdentityHashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.NavigableMap;
import java.util.NavigableSet;
import java.util.Properties;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.concurrent.ConcurrentMap;
import java.util.function.BinaryOperator;
import java.util.stream.Collector;

public class Maps
{
    protected Maps() {}
    abstract static class IteratorBasedAbstractMap<K, V> extends AbstractMap<K, V> {
        public Set<Map.Entry<K, V>> entrySet(){ return null; }
        public void clear(){}
    }
    public static <A, B> Converter<A, B> asConverter(BiMap<A, B> p0){ return null; }
    public static <C, K extends C, V> TreeMap<K, V> newTreeMap(Comparator<C> p0){ return null; }
    public static <K extends Comparable, V> TreeMap<K, V> newTreeMap(){ return null; }
    public static <K extends Comparable<? super K>, V> NavigableMap<K, V> subMap(NavigableMap<K, V> p0, Range<K> p1){ return null; }
    public static <K extends Enum<K>, V> EnumMap<K, V> newEnumMap(Class<K> p0){ return null; }
    public static <K extends Enum<K>, V> EnumMap<K, V> newEnumMap(Map<K, ? extends V> p0){ return null; }
    public static <K extends Enum<K>, V> ImmutableMap<K, V> immutableEnumMap(Map<K, ? extends V> p0){ return null; }
    public static <K, V1, V2> Map<K, V2> transformEntries(Map<K, V1> p0, Maps.EntryTransformer<? super K, ? super V1, V2> p1){ return null; }
    public static <K, V1, V2> Map<K, V2> transformValues(Map<K, V1> p0, Function<? super V1, V2> p1){ return null; }
    public static <K, V1, V2> NavigableMap<K, V2> transformEntries(NavigableMap<K, V1> p0, Maps.EntryTransformer<? super K, ? super V1, V2> p1){ return null; }
    public static <K, V1, V2> NavigableMap<K, V2> transformValues(NavigableMap<K, V1> p0, Function<? super V1, V2> p1){ return null; }
    public static <K, V1, V2> SortedMap<K, V2> transformEntries(SortedMap<K, V1> p0, Maps.EntryTransformer<? super K, ? super V1, V2> p1){ return null; }
    public static <K, V1, V2> SortedMap<K, V2> transformValues(SortedMap<K, V1> p0, Function<? super V1, V2> p1){ return null; }
    public static <K, V> BiMap<K, V> filterEntries(BiMap<K, V> p0, Predicate<? super Map.Entry<K, V>> p1){ return null; }
    public static <K, V> BiMap<K, V> filterKeys(BiMap<K, V> p0, Predicate<? super K> p1){ return null; }
    public static <K, V> BiMap<K, V> filterValues(BiMap<K, V> p0, Predicate<? super V> p1){ return null; }
    public static <K, V> BiMap<K, V> synchronizedBiMap(BiMap<K, V> p0){ return null; }
    public static <K, V> BiMap<K, V> unmodifiableBiMap(BiMap<? extends K, ? extends V> p0){ return null; }
    public static <K, V> ConcurrentMap<K, V> newConcurrentMap(){ return null; }
    public static <K, V> HashMap<K, V> newHashMap(){ return null; }
    public static <K, V> HashMap<K, V> newHashMap(Map<? extends K, ? extends V> p0){ return null; }
    public static <K, V> HashMap<K, V> newHashMapWithExpectedSize(int p0){ return null; }
    public static <K, V> IdentityHashMap<K, V> newIdentityHashMap(){ return null; }
    public static <K, V> ImmutableMap<K, V> toMap(Iterable<K> p0, Function<? super K, V> p1){ return null; }
    public static <K, V> ImmutableMap<K, V> toMap(Iterator<K> p0, Function<? super K, V> p1){ return null; }
    public static <K, V> ImmutableMap<K, V> uniqueIndex(Iterable<V> p0, Function<? super V, K> p1){ return null; }
    public static <K, V> ImmutableMap<K, V> uniqueIndex(Iterator<V> p0, Function<? super V, K> p1){ return null; }
    public static <K, V> LinkedHashMap<K, V> newLinkedHashMap(){ return null; }
    public static <K, V> LinkedHashMap<K, V> newLinkedHashMap(Map<? extends K, ? extends V> p0){ return null; }
    public static <K, V> LinkedHashMap<K, V> newLinkedHashMapWithExpectedSize(int p0){ return null; }
    public static <K, V> Map.Entry<K, V> immutableEntry(K p0, V p1){ return null; }
    public static <K, V> Map<K, V> asMap(Set<K> p0, Function<? super K, V> p1){ return null; }
    public static <K, V> Map<K, V> filterEntries(Map<K, V> p0, Predicate<? super Map.Entry<K, V>> p1){ return null; }
    public static <K, V> Map<K, V> filterKeys(Map<K, V> p0, Predicate<? super K> p1){ return null; }
    public static <K, V> Map<K, V> filterValues(Map<K, V> p0, Predicate<? super V> p1){ return null; }
    public static <K, V> MapDifference<K, V> difference(Map<? extends K, ? extends V> p0, Map<? extends K, ? extends V> p1){ return null; }
    public static <K, V> MapDifference<K, V> difference(Map<? extends K, ? extends V> p0, Map<? extends K, ? extends V> p1, Equivalence<? super V> p2){ return null; }
    public static <K, V> NavigableMap<K, V> asMap(NavigableSet<K> p0, Function<? super K, V> p1){ return null; }
    public static <K, V> NavigableMap<K, V> filterEntries(NavigableMap<K, V> p0, Predicate<? super Map.Entry<K, V>> p1){ return null; }
    public static <K, V> NavigableMap<K, V> filterKeys(NavigableMap<K, V> p0, Predicate<? super K> p1){ return null; }
    public static <K, V> NavigableMap<K, V> filterValues(NavigableMap<K, V> p0, Predicate<? super V> p1){ return null; }
    public static <K, V> NavigableMap<K, V> synchronizedNavigableMap(NavigableMap<K, V> p0){ return null; }
    public static <K, V> NavigableMap<K, V> unmodifiableNavigableMap(NavigableMap<K, ? extends V> p0){ return null; }
    public static <K, V> SortedMap<K, V> asMap(SortedSet<K> p0, Function<? super K, V> p1){ return null; }
    public static <K, V> SortedMap<K, V> filterEntries(SortedMap<K, V> p0, Predicate<? super Map.Entry<K, V>> p1){ return null; }
    public static <K, V> SortedMap<K, V> filterKeys(SortedMap<K, V> p0, Predicate<? super K> p1){ return null; }
    public static <K, V> SortedMap<K, V> filterValues(SortedMap<K, V> p0, Predicate<? super V> p1){ return null; }
    public static <K, V> SortedMapDifference<K, V> difference(SortedMap<K, ? extends V> p0, Map<? extends K, ? extends V> p1){ return null; }
    public static <K, V> TreeMap<K, V> newTreeMap(SortedMap<K, ? extends V> p0){ return null; }
    public static <T, K extends Enum<K>, V> Collector<T, ? extends Object, ImmutableMap<K, V>> toImmutableEnumMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1){ return null; }
    public static <T, K extends Enum<K>, V> Collector<T, ? extends Object, ImmutableMap<K, V>> toImmutableEnumMap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1, BinaryOperator<V> p2){ return null; }
    public static ImmutableMap<String, String> fromProperties(Properties p0){ return null; }
    static public interface EntryTransformer<K, V1, V2>
    {
        V2 transformEntry(K p0, V1 p1);
    }
}
