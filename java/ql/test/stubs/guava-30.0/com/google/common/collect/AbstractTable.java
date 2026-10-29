// Generated automatically from com.google.common.collect.AbstractTable for testing purposes

package com.google.common.collect;

import com.google.common.collect.Table;
import java.util.Collection;
import java.util.Set;

abstract class AbstractTable<R, C, V> implements Table<R, C, V>
{
    public Collection<V> values(){ return null; }
    public Set<C> columnKeySet(){ return null; }
    public Set<R> rowKeySet(){ return null; }
    public Set<Table.Cell<R, C, V>> cellSet(){ return null; }
    public String toString(){ return null; }
    public V get(Object p0, Object p1){ return null; }
    public V put(R p0, C p1, V p2){ return null; }
    public V remove(Object p0, Object p1){ return null; }
    public boolean contains(Object p0, Object p1){ return false; }
    public boolean containsColumn(Object p0){ return false; }
    public boolean containsRow(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public void clear(){}
    public void putAll(Table<? extends R, ? extends C, ? extends V> p0){}
}
