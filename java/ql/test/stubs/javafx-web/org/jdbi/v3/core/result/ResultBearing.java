// Generated automatically from org.jdbi.v3.core.result.ResultBearing for testing purposes

package org.jdbi.v3.core.result;

import java.lang.reflect.Type;
import java.sql.ResultSet;
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
import org.jdbi.v3.core.result.ResultIterable;
import org.jdbi.v3.core.result.ResultSetAccumulator;
import org.jdbi.v3.core.result.ResultSetScanner;
import org.jdbi.v3.core.result.RowReducer;
import org.jdbi.v3.core.result.RowView;
import org.jdbi.v3.core.statement.StatementContext;

public interface ResultBearing
{
    <R> R scanResultSet(org.jdbi.v3.core.result.ResultSetScanner<R> p0);
    default <A, R> R collectRows(java.util.stream.Collector<RowView, A, R> p0){ return null; }
    default <C, R> java.util.stream.Stream<R> reduceRows(org.jdbi.v3.core.result.RowReducer<C, R> p0){ return null; }
    default <K, V> java.util.stream.Stream<V> reduceRows(java.util.function.BiConsumer<java.util.Map<K, V>, RowView> p0){ return null; }
    default <R> R collectInto(java.lang.Class<R> p0){ return null; }
    default <R> R collectInto(org.jdbi.v3.core.generic.GenericType<R> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<T> map(org.jdbi.v3.core.mapper.ColumnMapper<T> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<T> map(org.jdbi.v3.core.mapper.RowMapper<T> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<T> map(org.jdbi.v3.core.mapper.RowViewMapper<T> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<T> mapTo(java.lang.Class<T> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<T> mapTo(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<T> mapTo(org.jdbi.v3.core.qualifier.QualifiedType<T> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<T> mapToBean(java.lang.Class<T> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<java.util.Map<String, T>> mapToMap(java.lang.Class<T> p0){ return null; }
    default <T> org.jdbi.v3.core.result.ResultIterable<java.util.Map<String, T>> mapToMap(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    default <U> U reduceResultSet(U p0, org.jdbi.v3.core.result.ResultSetAccumulator<U> p1){ return null; }
    default <U> U reduceRows(U p0, java.util.function.BiFunction<U, RowView, U> p1){ return null; }
    default Object collectInto(Type p0){ return null; }
    default ResultIterable<? extends Object> mapTo(Type p0){ return null; }
    default ResultIterable<Map<String, Object>> mapToMap(){ return null; }
    static ResultBearing of(Supplier<ResultSet> p0, StatementContext p1){ return null; }
}
