// Generated automatically from com.google.common.collect.RowSortedTable for testing purposes

package com.google.common.collect;

import com.google.common.collect.Table;
import java.util.Map;
import java.util.SortedMap;
import java.util.SortedSet;

public interface RowSortedTable<R, C, V> extends Table<R, C, V>
{
    SortedMap<R, Map<C, V>> rowMap();
    SortedSet<R> rowKeySet();
}
