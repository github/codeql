// Generated automatically from org.springframework.util.MultiValueMapAdapter for testing purposes

package org.springframework.util;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.util.MultiValueMap;

public class MultiValueMapAdapter<K, V> implements MultiValueMap<K, V>, Serializable
{
    protected MultiValueMapAdapter() {}
    public Collection<List<V>> values(){ return null; }
    public List<V> get(Object p0){ return null; }
    public List<V> put(K p0, List<V> p1){ return null; }
    public List<V> remove(Object p0){ return null; }
    public Map<K, V> toSingleValueMap(){ return null; }
    public MultiValueMapAdapter(Map<K, List<V>> p0){}
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, List<V>>> entrySet(){ return null; }
    public String toString(){ return null; }
    public V getFirst(K p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public void add(K p0, V p1){}
    public void addAll(K p0, List<? extends V> p1){}
    public void addAll(MultiValueMap<K, V> p0){}
    public void clear(){}
    public void putAll(Map<? extends K, ? extends List<V>> p0){}
    public void set(K p0, V p1){}
    public void setAll(Map<K, V> p0){}
}
