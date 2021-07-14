// Generated automatically from com.google.common.collect.StandardTable for testing purposes

package com.google.common.collect;

import com.google.common.base.Supplier;
import com.google.common.collect.AbstractTable;
import com.google.common.collect.Table;
import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Spliterator;

class StandardTable<R, C, V> extends AbstractTable<R, C, V> implements Serializable
{
    protected StandardTable() {}
    Iterator<C> createColumnKeyIterator(){ return null; }
    Iterator<Table.Cell<R, C, V>> cellIterator(){ return null; }
    Map<R, Map<C, V>> createRowMap(){ return null; }
    Spliterator<Table.Cell<R, C, V>> cellSpliterator(){ return null; }
    StandardTable(Map<R, Map<C, V>> p0, Supplier<? extends Map<C, V>> p1){}
    final Map<R, Map<C, V>> backingMap = null;
    final Supplier<? extends Map<C, V>> factory = null;
    public Collection<V> values(){ return null; }
    public Map<C, Map<R, V>> columnMap(){ return null; }
    public Map<C, V> row(R p0){ return null; }
    public Map<R, Map<C, V>> rowMap(){ return null; }
    public Map<R, V> column(C p0){ return null; }
    public Set<C> columnKeySet(){ return null; }
    public Set<R> rowKeySet(){ return null; }
    public Set<Table.Cell<R, C, V>> cellSet(){ return null; }
    public V get(Object p0, Object p1){ return null; }
    public V put(R p0, C p1, V p2){ return null; }
    public V remove(Object p0, Object p1){ return null; }
    public boolean contains(Object p0, Object p1){ return false; }
    public boolean containsColumn(Object p0){ return false; }
    public boolean containsRow(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int size(){ return 0; }
    public void clear(){}
}
