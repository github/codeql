// Generated automatically from com.google.common.collect.Multimaps for testing purposes, and adjusted manually

package com.google.common.collect;

import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.base.Supplier;
import com.google.common.collect.ImmutableListMultimap;
import com.google.common.collect.ImmutableMultimap;
import com.google.common.collect.ImmutableSetMultimap;
import com.google.common.collect.ListMultimap;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.common.collect.SetMultimap;
import com.google.common.collect.SortedSetMultimap;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.stream.Collector;
import java.util.stream.Stream;

public class Multimaps
{
    protected Multimaps() {}
    public static <K, V, M extends Multimap<K, V>> M invertFrom(Multimap<? extends V, ? extends K> p0, M p1){ return null; }
    public static <K, V1, V2> ListMultimap<K, V2> transformEntries(ListMultimap<K, V1> p0, Maps.EntryTransformer<? super K, ? super V1, V2> p1){ return null; }
    public static <K, V1, V2> ListMultimap<K, V2> transformValues(ListMultimap<K, V1> p0, Function<? super V1, V2> p1){ return null; }
    public static <K, V1, V2> Multimap<K, V2> transformEntries(Multimap<K, V1> p0, Maps.EntryTransformer<? super K, ? super V1, V2> p1){ return null; }
    public static <K, V1, V2> Multimap<K, V2> transformValues(Multimap<K, V1> p0, Function<? super V1, V2> p1){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> index(Iterable<V> p0, Function<? super V, K> p1){ return null; }
    public static <K, V> ImmutableListMultimap<K, V> index(Iterator<V> p0, Function<? super V, K> p1){ return null; }
    public static <K, V> ListMultimap<K, V> filterKeys(ListMultimap<K, V> p0, Predicate<? super K> p1){ return null; }
    public static <K, V> ListMultimap<K, V> newListMultimap(Map<K, Collection<V>> p0, Supplier<? extends List<V>> p1){ return null; }
    public static <K, V> ListMultimap<K, V> synchronizedListMultimap(ListMultimap<K, V> p0){ return null; }
    public static <K, V> ListMultimap<K, V> unmodifiableListMultimap(ImmutableListMultimap<K, V> p0){ return null; }
    public static <K, V> ListMultimap<K, V> unmodifiableListMultimap(ListMultimap<K, V> p0){ return null; }
    public static <K, V> Map<K, Collection<V>> asMap(Multimap<K, V> p0){ return null; }
    public static <K, V> Map<K, List<V>> asMap(ListMultimap<K, V> p0){ return null; }
    public static <K, V> Map<K, Set<V>> asMap(SetMultimap<K, V> p0){ return null; }
    public static <K, V> Map<K, SortedSet<V>> asMap(SortedSetMultimap<K, V> p0){ return null; }
    public static <K, V> Multimap<K, V> filterEntries(Multimap<K, V> p0, Predicate<? super Map.Entry<K, V>> p1){ return null; }
    public static <K, V> Multimap<K, V> filterKeys(Multimap<K, V> p0, Predicate<? super K> p1){ return null; }
    public static <K, V> Multimap<K, V> filterValues(Multimap<K, V> p0, Predicate<? super V> p1){ return null; }
    public static <K, V> Multimap<K, V> newMultimap(Map<K, Collection<V>> p0, Supplier<? extends Collection<V>> p1){ return null; }
    public static <K, V> Multimap<K, V> synchronizedMultimap(Multimap<K, V> p0){ return null; }
    public static <K, V> Multimap<K, V> unmodifiableMultimap(ImmutableMultimap<K, V> p0){ return null; }
    public static <K, V> Multimap<K, V> unmodifiableMultimap(Multimap<K, V> p0){ return null; }
    public static <K, V> SetMultimap<K, V> filterEntries(SetMultimap<K, V> p0, Predicate<? super Map.Entry<K, V>> p1){ return null; }
    public static <K, V> SetMultimap<K, V> filterKeys(SetMultimap<K, V> p0, Predicate<? super K> p1){ return null; }
    public static <K, V> SetMultimap<K, V> filterValues(SetMultimap<K, V> p0, Predicate<? super V> p1){ return null; }
    public static <K, V> SetMultimap<K, V> forMap(Map<K, V> p0){ return null; }
    public static <K, V> SetMultimap<K, V> newSetMultimap(Map<K, Collection<V>> p0, Supplier<? extends Set<V>> p1){ return null; }
    public static <K, V> SetMultimap<K, V> synchronizedSetMultimap(SetMultimap<K, V> p0){ return null; }
    public static <K, V> SetMultimap<K, V> unmodifiableSetMultimap(ImmutableSetMultimap<K, V> p0){ return null; }
    public static <K, V> SetMultimap<K, V> unmodifiableSetMultimap(SetMultimap<K, V> p0){ return null; }
    public static <K, V> SortedSetMultimap<K, V> newSortedSetMultimap(Map<K, Collection<V>> p0, Supplier<? extends SortedSet<V>> p1){ return null; }
    public static <K, V> SortedSetMultimap<K, V> synchronizedSortedSetMultimap(SortedSetMultimap<K, V> p0){ return null; }
    public static <K, V> SortedSetMultimap<K, V> unmodifiableSortedSetMultimap(SortedSetMultimap<K, V> p0){ return null; }
    public static <T, K, V, M extends Multimap<K, V>> Collector<T, ? extends Object, M> flatteningToMultimap(Function<? super T, ? extends K> p0, Function<? super T, ? extends Stream<? extends V>> p1, Supplier<M> p2){ return null; }
    public static <T, K, V, M extends Multimap<K, V>> Collector<T, ? extends Object, M> toMultimap(Function<? super T, ? extends K> p0, Function<? super T, ? extends V> p1, Supplier<M> p2){ return null; }
}
