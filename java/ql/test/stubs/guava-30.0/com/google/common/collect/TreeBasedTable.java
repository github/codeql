// Generated automatically from com.google.common.collect.TreeBasedTable for testing purposes

package com.google.common.collect;

import com.google.common.collect.StandardRowSortedTable;
import java.util.Comparator;
import java.util.Map;
import java.util.SortedMap;
import java.util.SortedSet;

public class TreeBasedTable<R, C, V> extends StandardRowSortedTable<R, C, V>
{
    protected TreeBasedTable() {}
    public Comparator<? super C> columnComparator(){ return null; }
    public Comparator<? super R> rowComparator(){ return null; }
    public SortedMap<C, V> row(R p0){ return null; }
    public SortedMap<R, Map<C, V>> rowMap(){ return null; }
    public SortedSet<R> rowKeySet(){ return null; }
    public static <R extends Comparable, C extends Comparable, V> TreeBasedTable<R, C, V> create(){ return null; }
    public static <R, C, V> TreeBasedTable<R, C, V> create(Comparator<? super R> p0, Comparator<? super C> p1){ return null; }
    public static <R, C, V> TreeBasedTable<R, C, V> create(TreeBasedTable<R, C, ? extends V> p0){ return null; }
}
