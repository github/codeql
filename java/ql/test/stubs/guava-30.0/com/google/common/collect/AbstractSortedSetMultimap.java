// Generated automatically from com.google.common.collect.AbstractSortedSetMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractSetMultimap;
import com.google.common.collect.SortedSetMultimap;
import java.util.Collection;
import java.util.Map;
import java.util.SortedSet;

abstract class AbstractSortedSetMultimap<K, V> extends AbstractSetMultimap<K, V> implements SortedSetMultimap<K, V>
{
    protected AbstractSortedSetMultimap() {}
    <E> SortedSet<E> unmodifiableCollectionSubclass(Collection<E> p0){ return null; }
    Collection<V> wrapCollection(K p0, Collection<V> p1){ return null; }
    SortedSet<V> createUnmodifiableEmptyCollection(){ return null; }
    abstract SortedSet<V> createCollection();
    protected AbstractSortedSetMultimap(Map<K, Collection<V>> p0){}
    public Collection<V> values(){ return null; }
    public Map<K, Collection<V>> asMap(){ return null; }
    public SortedSet<V> get(K p0){ return null; }
    public SortedSet<V> removeAll(Object p0){ return null; }
    public SortedSet<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
}
