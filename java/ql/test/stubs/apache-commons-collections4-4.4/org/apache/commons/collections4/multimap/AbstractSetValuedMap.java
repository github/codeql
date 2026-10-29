// Generated automatically from org.apache.commons.collections4.multimap.AbstractSetValuedMap for testing purposes

package org.apache.commons.collections4.multimap;

import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.SetValuedMap;
import org.apache.commons.collections4.multimap.AbstractMultiValuedMap;

abstract public class AbstractSetValuedMap<K, V> extends AbstractMultiValuedMap<K, V> implements SetValuedMap<K, V>
{
    Set<V> wrappedCollection(K p0){ return null; }
    protected AbstractSetValuedMap(){}
    protected AbstractSetValuedMap(Map<K, ? extends Set<V>> p0){}
    protected Map<K, Set<V>> getMap(){ return null; }
    protected abstract Set<V> createCollection();
    public Set<V> get(K p0){ return null; }
    public Set<V> remove(Object p0){ return null; }
}
