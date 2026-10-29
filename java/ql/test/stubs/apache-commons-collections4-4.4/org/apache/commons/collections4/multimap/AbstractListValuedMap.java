// Generated automatically from org.apache.commons.collections4.multimap.AbstractListValuedMap for testing purposes

package org.apache.commons.collections4.multimap;

import java.util.List;
import java.util.Map;
import org.apache.commons.collections4.ListValuedMap;
import org.apache.commons.collections4.multimap.AbstractMultiValuedMap;

abstract public class AbstractListValuedMap<K, V> extends AbstractMultiValuedMap<K, V> implements ListValuedMap<K, V>
{
    List<V> wrappedCollection(K p0){ return null; }
    protected AbstractListValuedMap(){}
    protected AbstractListValuedMap(Map<K, ? extends List<V>> p0){}
    protected Map<K, List<V>> getMap(){ return null; }
    protected abstract List<V> createCollection();
    public List<V> get(K p0){ return null; }
    public List<V> remove(Object p0){ return null; }
}
