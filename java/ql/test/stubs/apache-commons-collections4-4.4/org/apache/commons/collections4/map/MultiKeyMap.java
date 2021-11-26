// Generated automatically from org.apache.commons.collections4.map.MultiKeyMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Map;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.keyvalue.MultiKey;
import org.apache.commons.collections4.map.AbstractHashedMap;
import org.apache.commons.collections4.map.AbstractMapDecorator;

public class MultiKeyMap<K, V> extends AbstractMapDecorator<MultiKey<? extends K>, V> implements Cloneable, Serializable
{
    protected AbstractHashedMap<MultiKey<? extends K>, V> decorated(){ return null; }
    protected MultiKeyMap(AbstractHashedMap<MultiKey<? extends K>, V> p0){}
    protected boolean isEqualKey(AbstractHashedMap.HashEntry<MultiKey<? extends K>, V> p0, Object p1, Object p2){ return false; }
    protected boolean isEqualKey(AbstractHashedMap.HashEntry<MultiKey<? extends K>, V> p0, Object p1, Object p2, Object p3){ return false; }
    protected boolean isEqualKey(AbstractHashedMap.HashEntry<MultiKey<? extends K>, V> p0, Object p1, Object p2, Object p3, Object p4){ return false; }
    protected boolean isEqualKey(AbstractHashedMap.HashEntry<MultiKey<? extends K>, V> p0, Object p1, Object p2, Object p3, Object p4, Object p5){ return false; }
    protected int hash(Object p0, Object p1){ return 0; }
    protected int hash(Object p0, Object p1, Object p2){ return 0; }
    protected int hash(Object p0, Object p1, Object p2, Object p3){ return 0; }
    protected int hash(Object p0, Object p1, Object p2, Object p3, Object p4){ return 0; }
    protected void checkKey(MultiKey<? extends Object> p0){}
    public MapIterator<MultiKey<? extends K>, V> mapIterator(){ return null; }
    public MultiKeyMap(){}
    public MultiKeyMap<K, V> clone(){ return null; }
    public V get(Object p0, Object p1){ return null; }
    public V get(Object p0, Object p1, Object p2){ return null; }
    public V get(Object p0, Object p1, Object p2, Object p3){ return null; }
    public V get(Object p0, Object p1, Object p2, Object p3, Object p4){ return null; }
    public V put(K p0, K p1, K p2, K p3, K p4, V p5){ return null; }
    public V put(K p0, K p1, K p2, K p3, V p4){ return null; }
    public V put(K p0, K p1, K p2, V p3){ return null; }
    public V put(K p0, K p1, V p2){ return null; }
    public V put(MultiKey<? extends K> p0, V p1){ return null; }
    public V removeMultiKey(Object p0, Object p1){ return null; }
    public V removeMultiKey(Object p0, Object p1, Object p2){ return null; }
    public V removeMultiKey(Object p0, Object p1, Object p2, Object p3){ return null; }
    public V removeMultiKey(Object p0, Object p1, Object p2, Object p3, Object p4){ return null; }
    public boolean containsKey(Object p0, Object p1){ return false; }
    public boolean containsKey(Object p0, Object p1, Object p2){ return false; }
    public boolean containsKey(Object p0, Object p1, Object p2, Object p3){ return false; }
    public boolean containsKey(Object p0, Object p1, Object p2, Object p3, Object p4){ return false; }
    public boolean removeAll(Object p0){ return false; }
    public boolean removeAll(Object p0, Object p1){ return false; }
    public boolean removeAll(Object p0, Object p1, Object p2){ return false; }
    public boolean removeAll(Object p0, Object p1, Object p2, Object p3){ return false; }
    public static <K, V> MultiKeyMap<K, V> multiKeyMap(AbstractHashedMap<MultiKey<? extends K>, V> p0){ return null; }
    public void putAll(Map<? extends MultiKey<? extends K>, ? extends V> p0){}
}
