// Generated automatically from com.google.common.collect.TreeMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractSortedKeySortedSetMultimap;
import com.google.common.collect.Multimap;
import java.util.Collection;
import java.util.Comparator;
import java.util.NavigableMap;
import java.util.NavigableSet;

public class TreeMultimap<K, V> extends AbstractSortedKeySortedSetMultimap<K, V>
{
    protected TreeMultimap() {}
    public Comparator<? super K> keyComparator(){ return null; }
    public Comparator<? super V> valueComparator(){ return null; }
    public NavigableMap<K, Collection<V>> asMap(){ return null; }
    public NavigableSet<K> keySet(){ return null; }
    public NavigableSet<V> get(K p0){ return null; }
    public static <K extends Comparable, V extends Comparable> TreeMultimap<K, V> create(){ return null; }
    public static <K extends Comparable, V extends Comparable> TreeMultimap<K, V> create(Multimap<? extends K, ? extends V> p0){ return null; }
    public static <K, V> TreeMultimap<K, V> create(Comparator<? super K> p0, Comparator<? super V> p1){ return null; }
}
