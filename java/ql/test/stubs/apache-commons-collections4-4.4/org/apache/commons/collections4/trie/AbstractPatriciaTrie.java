// Generated automatically from org.apache.commons.collections4.trie.AbstractPatriciaTrie for testing purposes

package org.apache.commons.collections4.trie;

import java.util.Collection;
import java.util.Comparator;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.trie.AbstractBitwiseTrie;
import org.apache.commons.collections4.trie.KeyAnalyzer;

abstract class AbstractPatriciaTrie<K, V> extends AbstractBitwiseTrie<K, V>
{
    protected AbstractPatriciaTrie() {}
    AbstractPatriciaTrie.TrieEntry<K, V> addEntry(AbstractPatriciaTrie.TrieEntry<K, V> p0, int p1){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> ceilingEntry(K p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> firstEntry(){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> floorEntry(K p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> followLeft(AbstractPatriciaTrie.TrieEntry<K, V> p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> followRight(AbstractPatriciaTrie.TrieEntry<K, V> p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> getEntry(Object p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> getNearestEntryForKey(K p0, int p1){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> higherEntry(K p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> lastEntry(){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> lowerEntry(K p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> nextEntry(AbstractPatriciaTrie.TrieEntry<K, V> p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> nextEntryImpl(AbstractPatriciaTrie.TrieEntry<K, V> p0, AbstractPatriciaTrie.TrieEntry<K, V> p1, AbstractPatriciaTrie.TrieEntry<K, V> p2){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> nextEntryInSubtree(AbstractPatriciaTrie.TrieEntry<K, V> p0, AbstractPatriciaTrie.TrieEntry<K, V> p1){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> previousEntry(AbstractPatriciaTrie.TrieEntry<K, V> p0){ return null; }
    AbstractPatriciaTrie.TrieEntry<K, V> subtree(K p0, int p1, int p2){ return null; }
    V removeEntry(AbstractPatriciaTrie.TrieEntry<K, V> p0){ return null; }
    protected AbstractPatriciaTrie(KeyAnalyzer<? super K> p0){}
    protected AbstractPatriciaTrie(KeyAnalyzer<? super K> p0, Map<? extends K, ? extends V> p1){}
    protected int modCount = 0;
    public Collection<V> values(){ return null; }
    public Comparator<? super K> comparator(){ return null; }
    public K firstKey(){ return null; }
    public K lastKey(){ return null; }
    public K nextKey(K p0){ return null; }
    public K previousKey(K p0){ return null; }
    public K selectKey(K p0){ return null; }
    public Map.Entry<K, V> select(K p0){ return null; }
    public OrderedMapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public SortedMap<K, V> headMap(K p0){ return null; }
    public SortedMap<K, V> prefixMap(K p0){ return null; }
    public SortedMap<K, V> subMap(K p0, K p1){ return null; }
    public SortedMap<K, V> tailMap(K p0){ return null; }
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public V selectValue(K p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public int size(){ return 0; }
    public void clear(){}
    static boolean isValidUplink(AbstractPatriciaTrie.TrieEntry<? extends Object, ? extends Object> p0, AbstractPatriciaTrie.TrieEntry<? extends Object, ? extends Object> p1){ return false; }
    static class TrieEntry<K, V> extends AbstractBitwiseTrie.BasicEntry<K, V>
    {
        protected TrieEntry() {}
        protected AbstractPatriciaTrie.TrieEntry<K, V> left = null;
        protected AbstractPatriciaTrie.TrieEntry<K, V> parent = null;
        protected AbstractPatriciaTrie.TrieEntry<K, V> predecessor = null;
        protected AbstractPatriciaTrie.TrieEntry<K, V> right = null;
        protected int bitIndex = 0;
        public String toString(){ return null; }
        public TrieEntry(K p0, V p1, int p2){}
        public boolean isEmpty(){ return false; }
        public boolean isExternalNode(){ return false; }
        public boolean isInternalNode(){ return false; }
    }
    void decrementSize(){}
    void incrementSize(){}
}
