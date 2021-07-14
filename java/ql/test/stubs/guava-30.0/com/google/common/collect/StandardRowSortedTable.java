// Generated automatically from com.google.common.collect.StandardRowSortedTable for testing purposes

package com.google.common.collect;

import com.google.common.base.Supplier;
import com.google.common.collect.RowSortedTable;
import com.google.common.collect.StandardTable;
import java.util.Map;
import java.util.SortedMap;
import java.util.SortedSet;

class StandardRowSortedTable<R, C, V> extends StandardTable<R, C, V> implements RowSortedTable<R, C, V>
{
    protected StandardRowSortedTable() {}
    SortedMap<R, Map<C, V>> createRowMap(){ return null; }
    StandardRowSortedTable(SortedMap<R, Map<C, V>> p0, Supplier<? extends Map<C, V>> p1){}
    public SortedMap<R, Map<C, V>> rowMap(){ return null; }
    public SortedSet<R> rowKeySet(){ return null; }
}
