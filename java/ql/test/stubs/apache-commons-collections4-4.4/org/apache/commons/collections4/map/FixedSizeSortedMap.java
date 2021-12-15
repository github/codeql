// Generated automatically from org.apache.commons.collections4.map.FixedSizeSortedMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import org.apache.commons.collections4.BoundedMap;
import org.apache.commons.collections4.map.AbstractSortedMapDecorator;

public class FixedSizeSortedMap<K, V> extends AbstractSortedMapDecorator<K, V> implements BoundedMap<K, V>, Serializable
{
    protected FixedSizeSortedMap() {}
    protected FixedSizeSortedMap(SortedMap<K, V> p0){}
    protected SortedMap<K, V> getSortedMap(){ return null; }
    public Collection<V> values(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean isFull(){ return false; }
    public int maxSize(){ return 0; }
    public static <K, V> FixedSizeSortedMap<K, V> fixedSizeSortedMap(SortedMap<K, V> p0){ return null; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
