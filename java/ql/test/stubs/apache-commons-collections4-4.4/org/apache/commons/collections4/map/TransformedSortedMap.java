// Generated automatically from org.apache.commons.collections4.map.TransformedSortedMap for testing purposes

package org.apache.commons.collections4.map;

import java.util.Comparator;
import java.util.SortedMap;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.map.TransformedMap;

public class TransformedSortedMap<K, V> extends TransformedMap<K, V> implements SortedMap<K, V>
{
    protected TransformedSortedMap() {}
    protected SortedMap<K, V> getSortedMap(){ return null; }
    protected TransformedSortedMap(SortedMap<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){}
    public Comparator<? super K> comparator(){ return null; }
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
    public static <K, V> TransformedSortedMap<K, V> transformedSortedMap(SortedMap<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){ return null; }
    public static <K, V> TransformedSortedMap<K, V> transformingSortedMap(SortedMap<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){ return null; }
}
