// Generated automatically from org.apache.commons.collections4.map.PredicatedSortedMap for testing purposes

package org.apache.commons.collections4.map;

import java.util.Comparator;
import java.util.SortedMap;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.map.PredicatedMap;

public class PredicatedSortedMap<K, V> extends PredicatedMap<K, V> implements SortedMap<K, V>
{
    protected PredicatedSortedMap() {}
    protected PredicatedSortedMap(SortedMap<K, V> p0, Predicate<? super K> p1, Predicate<? super V> p2){}
    protected SortedMap<K, V> getSortedMap(){ return null; }
    public Comparator<? super K> comparator(){ return null; }
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
    public static <K, V> PredicatedSortedMap<K, V> predicatedSortedMap(SortedMap<K, V> p0, Predicate<? super K> p1, Predicate<? super V> p2){ return null; }
}
