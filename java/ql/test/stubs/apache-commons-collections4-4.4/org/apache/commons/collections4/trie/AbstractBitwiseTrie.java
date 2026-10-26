// Generated automatically from org.apache.commons.collections4.trie.AbstractBitwiseTrie for testing purposes

package org.apache.commons.collections4.trie;

import java.io.Serializable;
import java.util.AbstractMap;
import java.util.Map;
import org.apache.commons.collections4.Trie;
import org.apache.commons.collections4.trie.KeyAnalyzer;

abstract public class AbstractBitwiseTrie<K, V> extends AbstractMap<K, V> implements Serializable, Trie<K, V>
{
    protected AbstractBitwiseTrie() {}
    abstract static class BasicEntry<K, V> implements Map.Entry<K, V>, Serializable
    {
        protected BasicEntry() {}
        protected K key = null;
        protected V value = null;
        public BasicEntry(K p0){}
        public BasicEntry(K p0, V p1){}
        public K getKey(){ return null; }
        public String toString(){ return null; }
        public V getValue(){ return null; }
        public V setKeyValue(K p0, V p1){ return null; }
        public V setValue(V p0){ return null; }
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
    }
    final K castKey(Object p0){ return null; }
    final boolean compareKeys(K p0, K p1){ return false; }
    final boolean isBitSet(K p0, int p1, int p2){ return false; }
    final int bitIndex(K p0, K p1){ return 0; }
    final int bitsPerElement(){ return 0; }
    final int lengthInBits(K p0){ return 0; }
    protected AbstractBitwiseTrie(KeyAnalyzer<? super K> p0){}
    protected KeyAnalyzer<? super K> getKeyAnalyzer(){ return null; }
    public String toString(){ return null; }
    static boolean compare(Object p0, Object p1){ return false; }
}
