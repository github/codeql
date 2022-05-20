// Generated automatically from org.apache.commons.collections4.bidimap.DualTreeBidiMap for testing purposes

package org.apache.commons.collections4.bidimap;

import java.io.Serializable;
import java.util.Comparator;
import java.util.Map;
import java.util.SortedMap;
import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.OrderedBidiMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.SortedBidiMap;
import org.apache.commons.collections4.bidimap.AbstractDualBidiMap;

public class DualTreeBidiMap<K, V> extends AbstractDualBidiMap<K, V> implements Serializable, SortedBidiMap<K, V>
{
    protected DualTreeBidiMap(Map<K, V> p0, Map<V, K> p1, BidiMap<V, K> p2){}
    protected DualTreeBidiMap<V, K> createBidiMap(Map<V, K> p0, Map<K, V> p1, BidiMap<K, V> p2){ return null; }
    public Comparator<? super K> comparator(){ return null; }
    public Comparator<? super V> valueComparator(){ return null; }
    public DualTreeBidiMap(){}
    public DualTreeBidiMap(Comparator<? super K> p0, Comparator<? super V> p1){}
    public DualTreeBidiMap(Map<? extends K, ? extends V> p0){}
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public K nextKey(K p0){ return null; }
    public K previousKey(K p0){ return null; }
    public OrderedBidiMap<V, K> inverseOrderedBidiMap(){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
    public SortedBidiMap<V, K> inverseBidiMap(){ return null; }
    public SortedBidiMap<V, K> inverseSortedBidiMap(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
}
