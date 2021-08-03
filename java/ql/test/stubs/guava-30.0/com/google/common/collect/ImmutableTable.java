// Generated automatically from com.google.common.collect.ImmutableTable for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractTable;
import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Table;
import java.io.Serializable;
import java.util.Comparator;
import java.util.Map;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.stream.Collector;

abstract public class ImmutableTable<R, C, V> extends AbstractTable<R, C, V> implements Serializable
{
    public ImmutableCollection<V> values(){ return null; }
    public ImmutableMap<C, V> row(R p0){ return null; }
    public ImmutableMap<R, V> column(C p0){ return null; }
    public ImmutableSet<C> columnKeySet(){ return null; }
    public ImmutableSet<R> rowKeySet(){ return null; }
    public ImmutableSet<Table.Cell<R, C, V>> cellSet(){ return null; }
    public abstract ImmutableMap<C, Map<R, V>> columnMap();
    public abstract ImmutableMap<R, Map<C, V>> rowMap();
    public boolean contains(Object p0, Object p1){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public final V put(R p0, C p1, V p2){ return null; }
    public final V remove(Object p0, Object p1){ return null; }
    public final void clear(){}
    public final void putAll(Table<? extends R, ? extends C, ? extends V> p0){}
    public static <R, C, V> ImmutableTable.Builder<R, C, V> builder(){ return null; }
    public static <R, C, V> ImmutableTable<R, C, V> copyOf(Table<? extends R, ? extends C, ? extends V> p0){ return null; }
    public static <R, C, V> ImmutableTable<R, C, V> of(){ return null; }
    public static <R, C, V> ImmutableTable<R, C, V> of(R p0, C p1, V p2){ return null; }
    public static <T, R, C, V> Collector<T, ? extends Object, ImmutableTable<R, C, V>> toImmutableTable(Function<? super T, ? extends R> p0, Function<? super T, ? extends C> p1, Function<? super T, ? extends V> p2){ return null; }
    public static <T, R, C, V> Collector<T, ? extends Object, ImmutableTable<R, C, V>> toImmutableTable(Function<? super T, ? extends R> p0, Function<? super T, ? extends C> p1, Function<? super T, ? extends V> p2, BinaryOperator<V> p3){ return null; }
    static public class Builder<R, C, V>
    {
        public Builder(){}
        public ImmutableTable.Builder<R, C, V> orderColumnsBy(Comparator<? super C> p0){ return null; }
        public ImmutableTable.Builder<R, C, V> orderRowsBy(Comparator<? super R> p0){ return null; }
        public ImmutableTable.Builder<R, C, V> put(R p0, C p1, V p2){ return null; }
        public ImmutableTable.Builder<R, C, V> put(Table.Cell<? extends R, ? extends C, ? extends V> p0){ return null; }
        public ImmutableTable.Builder<R, C, V> putAll(Table<? extends R, ? extends C, ? extends V> p0){ return null; }
        public ImmutableTable<R, C, V> build(){ return null; }
    }
}
