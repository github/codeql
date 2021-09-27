// Generated automatically from org.apache.commons.collections4.map.AbstractSortedMapDecorator for testing purposes

package org.apache.commons.collections4.map;

import java.util.Comparator;
import java.util.SortedMap;
import org.apache.commons.collections4.IterableSortedMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.map.AbstractMapDecorator;

abstract public class AbstractSortedMapDecorator<K, V> extends AbstractMapDecorator<K, V> implements IterableSortedMap<K, V>
{
    protected AbstractSortedMapDecorator(){}
    protected SortedMap<K, V> decorated(){ return null; }
    public AbstractSortedMapDecorator(SortedMap<K, V> p0){}
    public Comparator<? super K> comparator(){ return null; }
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public K nextKey(K p0){ return null; }
    public K previousKey(K p0){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
}
