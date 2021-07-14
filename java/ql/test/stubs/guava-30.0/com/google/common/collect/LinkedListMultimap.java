// Generated automatically from com.google.common.collect.LinkedListMultimap for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractMultimap;
import com.google.common.collect.ListMultimap;
import com.google.common.collect.Multimap;
import com.google.common.collect.Multiset;
import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class LinkedListMultimap<K, V> extends AbstractMultimap<K, V> implements ListMultimap<K, V>, Serializable
{
    Iterator<Map.Entry<K, V>> entryIterator(){ return null; }
    LinkedListMultimap(){}
    List<Map.Entry<K, V>> createEntries(){ return null; }
    List<V> createValues(){ return null; }
    Map<K, Collection<V>> createAsMap(){ return null; }
    Multiset<K> createKeys(){ return null; }
    Set<K> createKeySet(){ return null; }
    public List<Map.Entry<K, V>> entries(){ return null; }
    public List<V> get(K p0){ return null; }
    public List<V> removeAll(Object p0){ return null; }
    public List<V> replaceValues(K p0, Iterable<? extends V> p1){ return null; }
    public List<V> values(){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean put(K p0, V p1){ return false; }
    public int size(){ return 0; }
    public static <K, V> LinkedListMultimap<K, V> create(){ return null; }
    public static <K, V> LinkedListMultimap<K, V> create(Multimap<? extends K, ? extends V> p0){ return null; }
    public static <K, V> LinkedListMultimap<K, V> create(int p0){ return null; }
    public void clear(){}
}
