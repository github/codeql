// Generated automatically from org.apache.commons.collections4.multimap.UnmodifiableMultiValuedMap for testing purposes

package org.apache.commons.collections4.multimap;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.MultiSet;
import org.apache.commons.collections4.MultiValuedMap;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.multimap.AbstractMultiValuedMapDecorator;

public class UnmodifiableMultiValuedMap<K, V> extends AbstractMultiValuedMapDecorator<K, V> implements Unmodifiable
{
    protected UnmodifiableMultiValuedMap() {}
    public Collection<Map.Entry<K, V>> entries(){ return null; }
    public Collection<V> get(K p0){ return null; }
    public Collection<V> remove(Object p0){ return null; }
    public Collection<V> values(){ return null; }
    public Map<K, Collection<V>> asMap(){ return null; }
    public MapIterator<K, V> mapIterator(){ return null; }
    public MultiSet<K> keys(){ return null; }
    public Set<K> keySet(){ return null; }
    public boolean put(K p0, V p1){ return false; }
    public boolean putAll(K p0, Iterable<? extends V> p1){ return false; }
    public boolean putAll(Map<? extends K, ? extends V> p0){ return false; }
    public boolean putAll(MultiValuedMap<? extends K, ? extends V> p0){ return false; }
    public boolean removeMapping(Object p0, Object p1){ return false; }
    public static <K, V> UnmodifiableMultiValuedMap<K, V> unmodifiableMultiValuedMap(MultiValuedMap<? extends K, ? extends V> p0){ return null; }
    public void clear(){}
}
