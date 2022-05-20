// Generated automatically from org.apache.commons.collections4.bidimap.AbstractOrderedBidiMapDecorator for testing purposes

package org.apache.commons.collections4.bidimap;

import org.apache.commons.collections4.OrderedBidiMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.bidimap.AbstractBidiMapDecorator;

abstract public class AbstractOrderedBidiMapDecorator<K, V> extends AbstractBidiMapDecorator<K, V> implements OrderedBidiMap<K, V>
{
    protected AbstractOrderedBidiMapDecorator() {}
    protected AbstractOrderedBidiMapDecorator(OrderedBidiMap<K, V> p0){}
    protected OrderedBidiMap<K, V> decorated(){ return null; }
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public K nextKey(K p0){ return null; }
    public K previousKey(K p0){ return null; }
    public OrderedBidiMap<V, K> inverseBidiMap(){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
}
