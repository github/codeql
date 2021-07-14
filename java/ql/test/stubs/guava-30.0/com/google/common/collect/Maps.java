// Generated automatically from com.google.common.collect.Multimaps for testing purposes, and manually adjusted.

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
import com.google.common.collect.UnmodifiableIterator;
import java.util.AbstractMap;
import java.util.Collection;
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
import java.util.Spliterator;
import java.util.TreeMap;
import java.util.concurrent.ConcurrentMap;
import java.util.function.BinaryOperator;
import java.util.function.Consumer;
import java.util.stream.Collector;

public class Maps
{
    protected Maps() {}
    abstract static class IteratorBasedAbstractMap<K, V> extends AbstractMap<K, V>
    {
        IteratorBasedAbstractMap(){}
        Spliterator<Map.Entry<K, V>> entrySpliterator(){ return null; }
        abstract Iterator<Map.Entry<K, V>> entryIterator();
        public Set<Map.Entry<K, V>> entrySet(){ return null; }
        public abstract int size();
        public void clear(){}
        void forEachEntry(Consumer<? super Map.Entry<K, V>> p0){}
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
    static <E> Comparator<? super E> orNaturalOrder(Comparator<? super E> p0){ return null; }
    static <E> ImmutableMap<E, Integer> indexMap(Collection<E> p0){ return null; }
    static <K, V1, V2> Function<Map.Entry<K, V1>, Map.Entry<K, V2>> asEntryToEntryFunction(Maps.EntryTransformer<? super K, ? super V1, V2> p0){ return null; }
    static <K, V1, V2> Function<Map.Entry<K, V1>, V2> asEntryToValueFunction(Maps.EntryTransformer<? super K, ? super V1, V2> p0){ return null; }
    static <K, V1, V2> Function<V1, V2> asValueToValueFunction(Maps.EntryTransformer<? super K, V1, V2> p0, K p1){ return null; }
    static <K, V1, V2> Maps.EntryTransformer<K, V1, V2> asEntryTransformer(Function<? super V1, V2> p0){ return null; }
    static <K, V> Iterator<K> keyIterator(Iterator<Map.Entry<K, V>> p0){ return null; }
    static <K, V> Iterator<Map.Entry<K, V>> asMapEntryIterator(Set<K> p0, Function<? super K, V> p1){ return null; }
    static <K, V> Iterator<V> valueIterator(Iterator<Map.Entry<K, V>> p0){ return null; }
    static <K, V> Map.Entry<K, V> unmodifiableEntry(Map.Entry<? extends K, ? extends V> p0){ return null; }
    static <K, V> Set<Map.Entry<K, V>> unmodifiableEntrySet(Set<Map.Entry<K, V>> p0){ return null; }
    static <K, V> UnmodifiableIterator<Map.Entry<K, V>> unmodifiableEntryIterator(Iterator<Map.Entry<K, V>> p0){ return null; }
    static <K, V> boolean containsEntryImpl(Collection<Map.Entry<K, V>> p0, Object p1){ return false; }
    static <K, V> boolean removeEntryImpl(Collection<Map.Entry<K, V>> p0, Object p1){ return false; }
    static <K, V> void putAllImpl(Map<K, V> p0, Map<? extends K, ? extends V> p1){}
    static <K> Function<Map.Entry<K, ? extends Object>, K> keyFunction(){ return null; }
    static <K> K keyOrNull(Map.Entry<K, ? extends Object> p0){ return null; }
    static <K> Predicate<Map.Entry<K, ? extends Object>> keyPredicateOnEntries(Predicate<? super K> p0){ return null; }
    static <V2, K, V1> Map.Entry<K, V2> transformEntry(Maps.EntryTransformer<? super K, ? super V1, V2> p0, Map.Entry<K, V1> p1){ return null; }
    static <V> Function<Map.Entry<? extends Object, V>, V> valueFunction(){ return null; }
    static <V> Predicate<Map.Entry<? extends Object, V>> valuePredicateOnEntries(Predicate<? super V> p0){ return null; }
    static <V> V safeGet(Map<? extends Object, V> p0, Object p1){ return null; }
    static <V> V safeRemove(Map<? extends Object, V> p0, Object p1){ return null; }
    static <V> V valueOrNull(Map.Entry<? extends Object, V> p0){ return null; }
    static String toStringImpl(Map<? extends Object, ? extends Object> p0){ return null; }
    static boolean containsKeyImpl(Map<? extends Object, ? extends Object> p0, Object p1){ return false; }
    static boolean containsValueImpl(Map<? extends Object, ? extends Object> p0, Object p1){ return false; }
    static boolean equalsImpl(Map<? extends Object, ? extends Object> p0, Object p1){ return false; }
    static boolean safeContainsKey(Map<? extends Object, ? extends Object> p0, Object p1){ return false; }
    static int capacity(int p0){ return 0; }
    static public interface EntryTransformer<K, V1, V2>
    {
        V2 transformEntry(K p0, V1 p1);
    }
}
