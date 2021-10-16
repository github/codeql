// Generated automatically from org.apache.commons.collections4.bidimap.AbstractSortedBidiMapDecorator for testing purposes

package org.apache.commons.collections4.bidimap;

import java.util.Comparator;
import java.util.SortedMap;
import org.apache.commons.collections4.SortedBidiMap;
import org.apache.commons.collections4.bidimap.AbstractOrderedBidiMapDecorator;

abstract public class AbstractSortedBidiMapDecorator<K, V> extends AbstractOrderedBidiMapDecorator<K, V> implements SortedBidiMap<K, V>
{
    protected AbstractSortedBidiMapDecorator() {}
    protected SortedBidiMap<K, V> decorated(){ return null; }
    public AbstractSortedBidiMapDecorator(SortedBidiMap<K, V> p0){}
    public Comparator<? super K> comparator(){ return null; }
    public Comparator<? super V> valueComparator(){ return null; }
    public SortedBidiMap<V, K> inverseBidiMap(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
}
