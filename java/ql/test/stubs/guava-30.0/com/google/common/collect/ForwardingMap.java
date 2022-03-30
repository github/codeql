// Generated automatically from com.google.common.collect.ForwardingMap for testing purposes

package com.google.common.collect;

import com.google.common.collect.ForwardingObject;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

abstract public class ForwardingMap<K, V> extends ForwardingObject implements Map<K, V>
{
    protected ForwardingMap(){}
    protected String standardToString(){ return null; }
    protected V standardRemove(Object p0){ return null; }
    protected abstract Map<K, V> delegate();
    protected boolean standardContainsKey(Object p0){ return false; }
    protected boolean standardContainsValue(Object p0){ return false; }
    protected boolean standardEquals(Object p0){ return false; }
    protected boolean standardIsEmpty(){ return false; }
    protected int standardHashCode(){ return 0; }
    protected void standardClear(){}
    protected void standardPutAll(Map<? extends K, ? extends V> p0){}
    public Collection<V> values(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
