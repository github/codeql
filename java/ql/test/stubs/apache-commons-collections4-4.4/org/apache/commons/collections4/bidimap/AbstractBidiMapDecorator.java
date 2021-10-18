// Generated automatically from org.apache.commons.collections4.bidimap.AbstractBidiMapDecorator for testing purposes

package org.apache.commons.collections4.bidimap;

import java.util.Set;
import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.map.AbstractMapDecorator;

abstract public class AbstractBidiMapDecorator<K, V> extends AbstractMapDecorator<K, V> implements BidiMap<K, V>
{
    protected AbstractBidiMapDecorator() {}
    protected AbstractBidiMapDecorator(BidiMap<K, V> p0){}
    protected BidiMap<K, V> decorated(){ return null; }
    public BidiMap<V, K> inverseBidiMap(){ return null; }
    public K getKey(Object p0){ return null; }
    public K removeValue(Object p0){ return null; }
    public MapIterator<K, V> mapIterator(){ return null; }
    public Set<V> values(){ return null; }
}
