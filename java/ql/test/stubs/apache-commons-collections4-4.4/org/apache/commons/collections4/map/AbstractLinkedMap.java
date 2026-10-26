// Generated automatically from org.apache.commons.collections4.map.AbstractLinkedMap for testing purposes

package org.apache.commons.collections4.map;

import java.util.Iterator;
import java.util.Map;
import org.apache.commons.collections4.OrderedMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.map.AbstractHashedMap;

abstract public class AbstractLinkedMap<K, V> extends AbstractHashedMap<K, V> implements OrderedMap<K, V>
{
    AbstractLinkedMap.LinkEntry<K, V> header = null;
    protected AbstractLinkedMap(){}
    protected AbstractLinkedMap(Map<? extends K, ? extends V> p0){}
    protected AbstractLinkedMap(int p0){}
    protected AbstractLinkedMap(int p0, float p1){}
    protected AbstractLinkedMap(int p0, float p1, int p2){}
    protected AbstractLinkedMap.LinkEntry<K, V> createEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1, K p2, V p3){ return null; }
    protected AbstractLinkedMap.LinkEntry<K, V> entryAfter(AbstractLinkedMap.LinkEntry<K, V> p0){ return null; }
    protected AbstractLinkedMap.LinkEntry<K, V> entryBefore(AbstractLinkedMap.LinkEntry<K, V> p0){ return null; }
    protected AbstractLinkedMap.LinkEntry<K, V> getEntry(Object p0){ return null; }
    protected AbstractLinkedMap.LinkEntry<K, V> getEntry(int p0){ return null; }
    protected Iterator<K> createKeySetIterator(){ return null; }
    protected Iterator<Map.Entry<K, V>> createEntrySetIterator(){ return null; }
    protected Iterator<V> createValuesIterator(){ return null; }
    protected void addEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1){}
    protected void init(){}
    protected void removeEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1, AbstractHashedMap.HashEntry<K, V> p2){}
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public K nextKey(Object p0){ return null; }
    public K previousKey(Object p0){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
    public boolean containsValue(Object p0){ return false; }
    public void clear(){}
    static class LinkEntry<K, V> extends AbstractHashedMap.HashEntry<K, V>
    {
        protected LinkEntry() {}
        protected AbstractLinkedMap.LinkEntry<K, V> after = null;
        protected AbstractLinkedMap.LinkEntry<K, V> before = null;
        protected LinkEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1, Object p2, V p3){}
    }
}
