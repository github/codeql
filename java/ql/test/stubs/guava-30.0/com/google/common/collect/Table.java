// Generated automatically from com.google.common.collect.Table for testing purposes

package com.google.common.collect;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

public interface Table<R, C, V>
{
    Collection<V> values();
    Map<C, Map<R, V>> columnMap();
    Map<C, V> row(R p0);
    Map<R, Map<C, V>> rowMap();
    Map<R, V> column(C p0);
    Set<C> columnKeySet();
    Set<R> rowKeySet();
    Set<Table.Cell<R, C, V>> cellSet();
    V get(Object p0, Object p1);
    V put(R p0, C p1, V p2);
    V remove(Object p0, Object p1);
    boolean contains(Object p0, Object p1);
    boolean containsColumn(Object p0);
    boolean containsRow(Object p0);
    boolean containsValue(Object p0);
    boolean equals(Object p0);
    boolean isEmpty();
    int hashCode();
    int size();
    static public interface Cell<R, C, V>
    {
        C getColumnKey();
        R getRowKey();
        V getValue();
        boolean equals(Object p0);
        int hashCode();
    }
    void clear();
    void putAll(Table<? extends R, ? extends C, ? extends V> p0);
}
