// Generated automatically from org.jdbi.v3.core.result.BatchResultBearing for testing purposes

package org.jdbi.v3.core.result;

import java.lang.reflect.Type;
import java.util.Map;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Supplier;
import java.util.stream.Collector;
import java.util.stream.Stream;
import org.jdbi.v3.core.generic.GenericType;
import org.jdbi.v3.core.mapper.ColumnMapper;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.mapper.RowViewMapper;
import org.jdbi.v3.core.qualifier.QualifiedType;
import org.jdbi.v3.core.result.BatchResultIterable;
import org.jdbi.v3.core.result.ResultBearing;
import org.jdbi.v3.core.result.ResultSetAccumulator;
import org.jdbi.v3.core.result.ResultSetScanner;
import org.jdbi.v3.core.result.RowReducer;
import org.jdbi.v3.core.result.RowView;

public class BatchResultBearing implements ResultBearing
{
    protected BatchResultBearing() {}
    public <A, R> R collectRows(java.util.stream.Collector<RowView, A, R> p0){ return null; }
    public <C, R> java.util.stream.Stream<R> reduceRows(org.jdbi.v3.core.result.RowReducer<C, R> p0){ return null; }
    public <K, V> java.util.stream.Stream<V> reduceRows(java.util.function.BiConsumer<java.util.Map<K, V>, RowView> p0){ return null; }
    public <R> R collectInto(java.lang.Class<R> p0){ return null; }
    public <R> R collectInto(org.jdbi.v3.core.generic.GenericType<R> p0){ return null; }
    public <R> R scanResultSet(org.jdbi.v3.core.result.ResultSetScanner<R> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<T> map(org.jdbi.v3.core.mapper.ColumnMapper<T> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<T> map(org.jdbi.v3.core.mapper.RowMapper<T> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<T> map(org.jdbi.v3.core.mapper.RowViewMapper<T> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<T> mapTo(java.lang.Class<T> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<T> mapTo(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<T> mapTo(org.jdbi.v3.core.qualifier.QualifiedType<T> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<T> mapToBean(java.lang.Class<T> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<java.util.Map<String, T>> mapToMap(java.lang.Class<T> p0){ return null; }
    public <T> org.jdbi.v3.core.result.BatchResultIterable<java.util.Map<String, T>> mapToMap(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    public <U> U reduceResultSet(U p0, org.jdbi.v3.core.result.ResultSetAccumulator<U> p1){ return null; }
    public <U> U reduceRows(U p0, java.util.function.BiFunction<U, RowView, U> p1){ return null; }
    public BatchResultBearing(ResultBearing p0, Supplier<int[]> p1){}
    public BatchResultIterable<? extends Object> mapTo(Type p0){ return null; }
    public BatchResultIterable<Map<String, Object>> mapToMap(){ return null; }
    public Object collectInto(Type p0){ return null; }
    public int[] modifiedRowCounts(){ return null; }
}
