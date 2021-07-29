// Generated automatically from com.google.common.collect.ImmutableMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.BaseImmutableMultimap;
import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableMultiset;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Multimap;
import com.google.common.collect.UnmodifiableIterator;
import java.io.Serializable;
import java.util.Collection;
import java.util.Comparator;
import java.util.Map;
import java.util.Set;
import java.util.Spliterator;
import java.util.function.BiConsumer;

abstract public class ImmutableMultimap<K, V> extends BaseImmutableMultimap<K, V> implements Serializable
{
    protected ImmutableMultimap() {}
    ImmutableCollection<Map.Entry<K, V>> createEntries(){ return null; }
    ImmutableCollection<V> createValues(){ return null; }
    ImmutableMultimap(ImmutableMap<K, ? extends ImmutableCollection<V>> p0, int p1){}
    ImmutableMultiset<K> createKeys(){ return null; }
    Map<K, Collection<V>> createAsMap(){ return null; }
    Set<K> createKeySet(){ return null; }
    Spliterator<Map.Entry<K, V>> entrySpliterator(){ return null; }
    UnmodifiableIterator<Map.Entry<K, V>> entryIterator(){ return null; }
    UnmodifiableIterator<V> valueIterator(){ return null; }
    boolean isPartialView(){ return false; }
    final ImmutableMap<K, ? extends ImmutableCollection<V>> map = null;
    final int size = 0;
    public ImmutableCollection<Map.Entry<K, V>> entries(){ return null; }
    public ImmutableCollection<V> removeAll(Object p0){ return null; }
    public ImmutableCollection<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public ImmutableCollection<V> values(){ return null; }
    public ImmutableMap<K, Collection<V>> asMap(){ return null; }
    public ImmutableMultiset<K> keys(){ return null; }
    public ImmutableSet<K> keySet(){ return null; }
    public abstract ImmutableCollection<V> get(K p0);
    public abstract ImmutableMultimap<V, K> inverse();
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean put(K p0, V p1){ return false; }
    public boolean putAll(K p0, Iterable<? extends V> p1){ return false; }
    public boolean putAll(Multimap<? extends K, ? extends V> p0){ return false; }
    public boolean remove(Object p0, Object p1){ return false; }
    public int size(){ return 0; }
    public static <K, V> ImmutableMultimap.Builder<K, V> builder(){ return null; }
    public static <K, V> ImmutableMultimap<K, V> copyOf(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
    public static <K, V> ImmutableMultimap<K, V> copyOf(Multimap<? extends K, ? extends V> p0){ return null; }
    public static <K, V> ImmutableMultimap<K, V> of(){ return null; }
    public static <K, V> ImmutableMultimap<K, V> of(K p0, V p1){ return null; }
    public static <K, V> ImmutableMultimap<K, V> of(K p0, V p1, K p2, V p3){ return null; }
    public static <K, V> ImmutableMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5){ return null; }
    public static <K, V> ImmutableMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7){ return null; }
    public static <K, V> ImmutableMultimap<K, V> of(K p0, V p1, K p2, V p3, K p4, V p5, K p6, V p7, K p8, V p9){ return null; }
    public void clear(){}
    public void forEach(BiConsumer<? super K, ? super V> p0){}
    static public class Builder<K, V>
    {
        Collection<V> newMutableValueCollection(){ return null; }
        Comparator<? super K> keyComparator = null;
        Comparator<? super V> valueComparator = null;
        ImmutableMultimap.Builder<K, V> combine(ImmutableMultimap.Builder<K, V> p0){ return null; }
        Map<K, Collection<V>> builderMap = null;
        public Builder(){}
        public ImmutableMultimap.Builder<K, V> orderKeysBy(Comparator<? super K> p0){ return null; }
        public ImmutableMultimap.Builder<K, V> orderValuesBy(Comparator<? super V> p0){ return null; }
        public ImmutableMultimap.Builder<K, V> put(K p0, V p1){ return null; }
        public ImmutableMultimap.Builder<K, V> put(Map.Entry<? extends K, ? extends V> p0){ return null; }
        public ImmutableMultimap.Builder<K, V> putAll(Iterable<? extends Map.Entry<? extends K, ? extends V>> p0){ return null; }
        public ImmutableMultimap.Builder<K, V> putAll(K p0, Iterable<? extends V> p1){ return null; }
        public ImmutableMultimap.Builder<K, V> putAll(K p0, V... p1){ return null; }
        public ImmutableMultimap.Builder<K, V> putAll(Multimap<? extends K, ? extends V> p0){ return null; }
        public ImmutableMultimap<K, V> build(){ return null; }
    }
}
