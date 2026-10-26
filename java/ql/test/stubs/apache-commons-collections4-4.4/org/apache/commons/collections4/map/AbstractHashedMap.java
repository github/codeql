// Generated automatically from org.apache.commons.collections4.map.AbstractHashedMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.AbstractCollection;
import java.util.AbstractMap;
import java.util.AbstractSet;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.IterableMap;
import org.apache.commons.collections4.KeyValue;
import org.apache.commons.collections4.MapIterator;

public class AbstractHashedMap<K, V> extends AbstractMap<K, V> implements IterableMap<K, V>
{
    AbstractHashedMap.EntrySet<K, V> entrySet = null;
    AbstractHashedMap.HashEntry<K, V>[] data = null;
    AbstractHashedMap.KeySet<K> keySet = null;
    AbstractHashedMap.Values<V> values = null;
    float loadFactor = 0;
    int modCount = 0;
    int size = 0;
    int threshold = 0;
    protected AbstractHashedMap(){}
    protected AbstractHashedMap(Map<? extends K, ? extends V> p0){}
    protected AbstractHashedMap(int p0){}
    protected AbstractHashedMap(int p0, float p1){}
    protected AbstractHashedMap(int p0, float p1, int p2){}
    protected AbstractHashedMap.HashEntry<K, V> createEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1, K p2, V p3){ return null; }
    protected AbstractHashedMap.HashEntry<K, V> entryNext(AbstractHashedMap.HashEntry<K, V> p0){ return null; }
    protected AbstractHashedMap.HashEntry<K, V> getEntry(Object p0){ return null; }
    protected AbstractHashedMap<K, V> clone(){ return null; }
    protected Iterator<K> createKeySetIterator(){ return null; }
    protected Iterator<Map.Entry<K, V>> createEntrySetIterator(){ return null; }
    protected Iterator<V> createValuesIterator(){ return null; }
    protected K entryKey(AbstractHashedMap.HashEntry<K, V> p0){ return null; }
    protected Object convertKey(Object p0){ return null; }
    protected V entryValue(AbstractHashedMap.HashEntry<K, V> p0){ return null; }
    protected boolean isEqualKey(Object p0, Object p1){ return false; }
    protected boolean isEqualValue(Object p0, Object p1){ return false; }
    protected int calculateNewCapacity(int p0){ return 0; }
    protected int calculateThreshold(int p0, float p1){ return 0; }
    protected int entryHashCode(AbstractHashedMap.HashEntry<K, V> p0){ return 0; }
    protected int hash(Object p0){ return 0; }
    protected int hashIndex(int p0, int p1){ return 0; }
    protected static Object NULL = null;
    protected static String GETKEY_INVALID = null;
    protected static String GETVALUE_INVALID = null;
    protected static String NO_NEXT_ENTRY = null;
    protected static String NO_PREVIOUS_ENTRY = null;
    protected static String REMOVE_INVALID = null;
    protected static String SETVALUE_INVALID = null;
    protected static float DEFAULT_LOAD_FACTOR = 0;
    protected static int DEFAULT_CAPACITY = 0;
    protected static int DEFAULT_THRESHOLD = 0;
    protected static int MAXIMUM_CAPACITY = 0;
    protected void addEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1){}
    protected void addMapping(int p0, int p1, K p2, V p3){}
    protected void checkCapacity(){}
    protected void destroyEntry(AbstractHashedMap.HashEntry<K, V> p0){}
    protected void doReadObject(ObjectInputStream p0){}
    protected void doWriteObject(ObjectOutputStream p0){}
    protected void ensureCapacity(int p0){}
    protected void init(){}
    protected void removeEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1, AbstractHashedMap.HashEntry<K, V> p2){}
    protected void removeMapping(AbstractHashedMap.HashEntry<K, V> p0, int p1, AbstractHashedMap.HashEntry<K, V> p2){}
    protected void reuseEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1, int p2, K p3, V p4){}
    protected void updateEntry(AbstractHashedMap.HashEntry<K, V> p0, V p1){}
    public Collection<V> values(){ return null; }
    public MapIterator<K, V> mapIterator(){ return null; }
    public Set<K> keySet(){ return null; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
    public String toString(){ return null; }
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public void clear(){}
    public void putAll(Map<? extends K, ? extends V> p0){}
    static class EntrySet<K, V> extends AbstractSet<Map.Entry<K, V>>
    {
        protected EntrySet() {}
        protected EntrySet(AbstractHashedMap<K, V> p0){}
        public Iterator<Map.Entry<K, V>> iterator(){ return null; }
        public boolean contains(Object p0){ return false; }
        public boolean remove(Object p0){ return false; }
        public int size(){ return 0; }
        public void clear(){}
    }
    static class HashEntry<K, V> implements KeyValue<K, V>, Map.Entry<K, V>
    {
        protected HashEntry() {}
        protected AbstractHashedMap.HashEntry<K, V> next = null;
        protected HashEntry(AbstractHashedMap.HashEntry<K, V> p0, int p1, Object p2, V p3){}
        protected Object key = null;
        protected Object value = null;
        protected int hashCode = 0;
        public K getKey(){ return null; }
        public String toString(){ return null; }
        public V getValue(){ return null; }
        public V setValue(V p0){ return null; }
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
    }
    static class KeySet<K> extends AbstractSet<K>
    {
        protected KeySet() {}
        protected KeySet(AbstractHashedMap<K, ? extends Object> p0){}
        public Iterator<K> iterator(){ return null; }
        public boolean contains(Object p0){ return false; }
        public boolean remove(Object p0){ return false; }
        public int size(){ return 0; }
        public void clear(){}
    }
    static class Values<V> extends AbstractCollection<V>
    {
        protected Values() {}
        protected Values(AbstractHashedMap<? extends Object, V> p0){}
        public Iterator<V> iterator(){ return null; }
        public boolean contains(Object p0){ return false; }
        public int size(){ return 0; }
        public void clear(){}
    }
}
