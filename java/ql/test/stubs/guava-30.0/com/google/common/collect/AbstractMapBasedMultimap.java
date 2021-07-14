// Generated automatically from com.google.common.collect.AbstractMapBasedMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractMultimap;
import com.google.common.collect.Multiset;
import java.io.Serializable;
import java.util.AbstractCollection;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Spliterator;
import java.util.function.BiConsumer;

abstract class AbstractMapBasedMultimap<K, V> extends AbstractMultimap<K, V> implements Serializable
{
    protected AbstractMapBasedMultimap() {}
    <E> Collection<E> unmodifiableCollectionSubclass(Collection<E> p0){ return null; }
    Collection<Map.Entry<K, V>> createEntries(){ return null; }
    Collection<V> createCollection(K p0){ return null; }
    Collection<V> createUnmodifiableEmptyCollection(){ return null; }
    Collection<V> createValues(){ return null; }
    Collection<V> wrapCollection(K p0, Collection<V> p1){ return null; }
    Iterator<Map.Entry<K, V>> entryIterator(){ return null; }
    Iterator<V> valueIterator(){ return null; }
    Map<K, Collection<V>> backingMap(){ return null; }
    Map<K, Collection<V>> createAsMap(){ return null; }
    Multiset<K> createKeys(){ return null; }
    Set<K> createKeySet(){ return null; }
    Spliterator<Map.Entry<K, V>> entrySpliterator(){ return null; }
    Spliterator<V> valueSpliterator(){ return null; }
    abstract Collection<V> createCollection();
    class WrappedCollection extends AbstractCollection<V>
    {
        protected WrappedCollection() {}
        AbstractMapBasedMultimap.WrappedCollection getAncestor(){ return null; }
        Collection<V> delegate = null;
        Collection<V> getDelegate(){ return null; }
        K getKey(){ return null; }
        WrappedCollection(K p0, Collection<V> p1, AbstractMapBasedMultimap.WrappedCollection p2){}
        final AbstractMapBasedMultimap.WrappedCollection ancestor = null;
        final Collection<V> ancestorDelegate = null;
        final K key = null;
        public Iterator<V> iterator(){ return null; }
        public Spliterator<V> spliterator(){ return null; }
        public String toString(){ return null; }
        public boolean add(V p0){ return false; }
        public boolean addAll(Collection<? extends V> p0){ return false; }
        public boolean contains(Object p0){ return false; }
        public boolean containsAll(Collection<? extends Object> p0){ return false; }
        public boolean equals(Object p0){ return false; }
        public boolean remove(Object p0){ return false; }
        public boolean removeAll(Collection<? extends Object> p0){ return false; }
        public boolean retainAll(Collection<? extends Object> p0){ return false; }
        public int hashCode(){ return 0; }
        public int size(){ return 0; }
        public void clear(){}
        void addToMap(){}
        void refreshIfEmpty(){}
        void removeIfEmpty(){}
    }
    final List<V> wrapList(K p0, List<V> p1, AbstractMapBasedMultimap.WrappedCollection p2){ return null; }
    final Map<K, Collection<V>> createMaybeNavigableAsMap(){ return null; }
    final Set<K> createMaybeNavigableKeySet(){ return null; }
    final void setMap(Map<K, Collection<V>> p0){}
    protected AbstractMapBasedMultimap(Map<K, Collection<V>> p0){}
    public Collection<Map.Entry<K, V>> entries(){ return null; }
    public Collection<V> get(K p0){ return null; }
    public Collection<V> removeAll(Object p0){ return null; }
    public Collection<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public Collection<V> values(){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean put(K p0, V p1){ return false; }
    public int size(){ return 0; }
    public void clear(){}
    public void forEach(BiConsumer<? super K, ? super V> p0){}
}
