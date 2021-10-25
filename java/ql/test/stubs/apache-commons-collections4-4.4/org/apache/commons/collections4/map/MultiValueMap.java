// Generated automatically from org.apache.commons.collections4.map.MultiValueMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.MultiMap;
import org.apache.commons.collections4.map.AbstractMapDecorator;

public class MultiValueMap<K, V> extends AbstractMapDecorator<K, Object> implements MultiMap<K, V>, Serializable
{
    protected <C extends Collection<V>> MultiValueMap(Map<K, ? super C> p0, Factory<C> p1){}
    protected Collection<V> createCollection(int p0){ return null; }
    public Collection<Object> values(){ return null; }
    public Collection<V> getCollection(Object p0){ return null; }
    public Iterator<Map.Entry<K, V>> iterator(){ return null; }
    public Iterator<V> iterator(Object p0){ return null; }
    public MultiValueMap(){}
    public Object put(K p0, Object p1){ return null; }
    public Set<Map.Entry<K, Object>> entrySet(){ return null; }
    public boolean containsValue(Object p0){ return false; }
    public boolean containsValue(Object p0, Object p1){ return false; }
    public boolean putAll(K p0, Collection<V> p1){ return false; }
    public boolean removeMapping(Object p0, Object p1){ return false; }
    public int size(Object p0){ return 0; }
    public int totalSize(){ return 0; }
    public static <K, V, C extends Collection<V>> MultiValueMap<K, V> multiValueMap(Map<K, ? super C> p0, Class<C> p1){ return null; }
    public static <K, V, C extends Collection<V>> MultiValueMap<K, V> multiValueMap(Map<K, ? super C> p0, Factory<C> p1){ return null; }
    public static <K, V> MultiValueMap<K, V> multiValueMap(Map<K, ? super Collection<V>> p0){ return null; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends Object> p0){}
}
