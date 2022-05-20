// Generated automatically from org.apache.commons.collections4.map.PassiveExpiringMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import org.apache.commons.collections4.map.AbstractMapDecorator;

public class PassiveExpiringMap<K, V> extends AbstractMapDecorator<K, V> implements Serializable
{
    public Collection<V> values(){ return null; }
    public PassiveExpiringMap(){}
    public PassiveExpiringMap(Map<K, V> p0){}
    public PassiveExpiringMap(PassiveExpiringMap.ExpirationPolicy<K, V> p0){}
    public PassiveExpiringMap(PassiveExpiringMap.ExpirationPolicy<K, V> p0, Map<K, V> p1){}
    public PassiveExpiringMap(long p0){}
    public PassiveExpiringMap(long p0, Map<K, V> p1){}
    public PassiveExpiringMap(long p0, TimeUnit p1){}
    public PassiveExpiringMap(long p0, TimeUnit p1, Map<K, V> p2){}
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int size(){ return 0; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
    static public interface ExpirationPolicy<K, V> extends Serializable
    {
        long expirationTime(K p0, V p1);
    }
}
