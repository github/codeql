// Generated automatically from com.google.common.collect.ArrayTable for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractTable;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Table;
import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

public class ArrayTable<R, C, V> extends AbstractTable<R, C, V> implements Serializable
{
    protected ArrayTable() {}
    public Collection<V> values(){ return null; }
    public ImmutableList<C> columnKeyList(){ return null; }
    public ImmutableList<R> rowKeyList(){ return null; }
    public ImmutableSet<C> columnKeySet(){ return null; }
    public ImmutableSet<R> rowKeySet(){ return null; }
    public Map<C, Map<R, V>> columnMap(){ return null; }
    public Map<C, V> row(R p0){ return null; }
    public Map<R, Map<C, V>> rowMap(){ return null; }
    public Map<R, V> column(C p0){ return null; }
    public Set<Table.Cell<R, C, V>> cellSet(){ return null; }
    public V at(int p0, int p1){ return null; }
    public V erase(Object p0, Object p1){ return null; }
    public V get(Object p0, Object p1){ return null; }
    public V put(R p0, C p1, V p2){ return null; }
    public V remove(Object p0, Object p1){ return null; }
    public V set(int p0, int p1, V p2){ return null; }
    public V[][] toArray(Class<V> p0){ return null; }
    public boolean contains(Object p0, Object p1){ return false; }
    public boolean containsColumn(Object p0){ return false; }
    public boolean containsRow(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int size(){ return 0; }
    public static <R, C, V> ArrayTable<R, C, V> create(Iterable<? extends R> p0, Iterable<? extends C> p1){ return null; }
    public static <R, C, V> ArrayTable<R, C, V> create(Table<R, C, V> p0){ return null; }
    public void clear(){}
    public void eraseAll(){}
    public void putAll(Table<? extends R, ? extends C, ? extends V> p0){}
}
