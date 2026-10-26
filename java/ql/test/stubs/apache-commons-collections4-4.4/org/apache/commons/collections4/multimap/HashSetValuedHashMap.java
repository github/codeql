// Generated automatically from org.apache.commons.collections4.multimap.HashSetValuedHashMap for testing purposes

package org.apache.commons.collections4.multimap;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Map;
import org.apache.commons.collections4.MultiValuedMap;
import org.apache.commons.collections4.multimap.AbstractSetValuedMap;

public class HashSetValuedHashMap<K, V> extends AbstractSetValuedMap<K, V> implements Serializable
{
    protected HashSet<V> createCollection(){ return null; }
    public HashSetValuedHashMap(){}
    public HashSetValuedHashMap(Map<? extends K, ? extends V> p0){}
    public HashSetValuedHashMap(MultiValuedMap<? extends K, ? extends V> p0){}
    public HashSetValuedHashMap(int p0){}
    public HashSetValuedHashMap(int p0, int p1){}
}
