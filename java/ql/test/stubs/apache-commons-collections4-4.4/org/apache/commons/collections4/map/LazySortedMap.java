// Generated automatically from org.apache.commons.collections4.map.LazySortedMap for testing purposes

package org.apache.commons.collections4.map;

import java.util.Comparator;
import java.util.SortedMap;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.map.LazyMap;

public class LazySortedMap<K, V> extends LazyMap<K, V> implements SortedMap<K, V>
{
    protected LazySortedMap() {}
    protected LazySortedMap(SortedMap<K, V> p0, Factory<? extends V> p1){}
    protected LazySortedMap(SortedMap<K, V> p0, Transformer<? super K, ? extends V> p1){}
    protected SortedMap<K, V> getSortedMap(){ return null; }
    public Comparator<? super K> comparator(){ return null; }
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
    public static <K, V> LazySortedMap<K, V> lazySortedMap(SortedMap<K, V> p0, Factory<? extends V> p1){ return null; }
    public static <K, V> LazySortedMap<K, V> lazySortedMap(SortedMap<K, V> p0, Transformer<? super K, ? extends V> p1){ return null; }
}
