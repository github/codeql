// Generated automatically from com.google.common.collect.HashBiMap for testing purposes

package com.google.common.collect;

import com.google.common.collect.BiMap;
import com.google.common.collect.Maps;
import java.io.Serializable;
import java.util.Map;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;

public class HashBiMap<K, V> extends Maps.IteratorBasedAbstractMap<K, V> implements BiMap<K, V>, Serializable
{
    protected HashBiMap() {}
    public BiMap<V, K> inverse(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<V> values(){ return null; }
    public V forcePut(K p0, V p1){ return null; }
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public int size(){ return 0; }
    public static <K, V> HashBiMap<K, V> create(){ return null; }
    public static <K, V> HashBiMap<K, V> create(Map<? extends K, ? extends V> p0){ return null; }
    public static <K, V> HashBiMap<K, V> create(int p0){ return null; }
    public void clear(){}
    public void forEach(BiConsumer<? super K, ? super V> p0){}
    public void replaceAll(BiFunction<? super K, ? super V, ? extends V> p0){}
}
