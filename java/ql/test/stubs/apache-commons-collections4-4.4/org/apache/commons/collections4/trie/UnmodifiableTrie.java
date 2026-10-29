// Generated automatically from org.apache.commons.collections4.trie.UnmodifiableTrie for testing purposes

package org.apache.commons.collections4.trie;

import java.io.Serializable;
import java.util.Collection;
import java.util.Comparator;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.Trie;
import org.apache.commons.collections4.Unmodifiable;

public class UnmodifiableTrie<K, V> implements Serializable, Trie<K, V>, Unmodifiable
{
    protected UnmodifiableTrie() {}
    public Collection<V> values(){ return null; }
    public Comparator<? super K> comparator(){ return null; }
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public K nextKey(K p0){ return null; }
    public K previousKey(K p0){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> prefixMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
    public String toString(){ return null; }
    public UnmodifiableTrie(Trie<K, ? extends V> p0){}
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public static <K, V> Trie<K, V> unmodifiableTrie(Trie<K, ? extends V> p0){ return null; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
}
