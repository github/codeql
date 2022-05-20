// Generated automatically from com.google.common.collect.Tables for testing purposes, and adjusted manually

package com.google.common.collect;

import com.google.common.base.Function;
import com.google.common.base.Supplier;
import com.google.common.collect.RowSortedTable;
import com.google.common.collect.Table;
import java.util.Map;
import java.util.function.BinaryOperator;
import java.util.stream.Collector;

public class Tables
{
    protected Tables() {}
    public static <R, C, V1, V2> Table<R, C, V2> transformValues(Table<R, C, V1> p0, Function<? super V1, V2> p1){ return null; }
    public static <R, C, V> RowSortedTable<R, C, V> unmodifiableRowSortedTable(RowSortedTable<R, ? extends C, ? extends V> p0){ return null; }
    public static <R, C, V> Table.Cell<R, C, V> immutableCell(R p0, C p1, V p2){ return null; }
    public static <R, C, V> Table<C, R, V> transpose(Table<R, C, V> p0){ return null; }
    public static <R, C, V> Table<R, C, V> newCustomTable(Map<R, Map<C, V>> p0, Supplier<? extends Map<C, V>> p1){ return null; }
    public static <R, C, V> Table<R, C, V> synchronizedTable(Table<R, C, V> p0){ return null; }
    public static <R, C, V> Table<R, C, V> unmodifiableTable(Table<? extends R, ? extends C, ? extends V> p0){ return null; }
    public static <T, R, C, V, I extends Table<R, C, V>> Collector<T, ? extends Object, I> toTable(Function<? super T, ? extends R> p0, Function<? super T, ? extends C> p1, Function<? super T, ? extends V> p2, BinaryOperator<V> p3, Supplier<I> p4){ return null; }
    public static <T, R, C, V, I extends Table<R, C, V>> Collector<T, ? extends Object, I> toTable(Function<? super T, ? extends R> p0, Function<? super T, ? extends C> p1, Function<? super T, ? extends V> p2, Supplier<I> p3){ return null; }
}
