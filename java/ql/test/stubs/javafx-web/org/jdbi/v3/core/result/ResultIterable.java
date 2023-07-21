// Generated automatically from org.jdbi.v3.core.result.ResultIterable for testing purposes

package org.jdbi.v3.core.result;

import java.sql.ResultSet;
import java.util.List;
import java.util.Optional;
import java.util.function.BiFunction;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.stream.Collector;
import java.util.stream.Stream;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.result.IteratorCallback;
import org.jdbi.v3.core.result.IteratorConsumer;
import org.jdbi.v3.core.result.ResultIterator;
import org.jdbi.v3.core.result.StreamCallback;
import org.jdbi.v3.core.result.StreamConsumer;
import org.jdbi.v3.core.statement.StatementContext;

public interface ResultIterable<T> extends java.lang.Iterable<T>
{
    default <R, X extends Exception> R withIterator(org.jdbi.v3.core.result.IteratorCallback<T, R, X> p0){ return null; }
    default <R, X extends Exception> R withStream(org.jdbi.v3.core.result.StreamCallback<T, R, X> p0){ return null; }
    default <R> R collect(java.util.stream.Collector<? super T, ? extends Object, R> p0){ return null; }
    default <R> ResultIterable<R> map(java.util.function.Function<? super T, ? extends R> p0){ return null; }
    default <U> U reduce(U p0, java.util.function.BiFunction<U, T, U> p1){ return null; }
    default <X extends Exception> void useIterator(org.jdbi.v3.core.result.IteratorConsumer<T, X> p0){}
    default <X extends Exception> void useStream(org.jdbi.v3.core.result.StreamConsumer<T, X> p0){}
    default ResultIterable<T> filter(java.util.function.Predicate<? super T> p0){ return null; }
    default T findOnly(){ return null; }
    default T first(){ return null; }
    default T one(){ return null; }
    default int forEachWithCount(java.util.function.Consumer<? super T> p0){ return 0; }
    default java.util.List<T> list(){ return null; }
    default java.util.Optional<T> findFirst(){ return null; }
    default java.util.Optional<T> findOne(){ return null; }
    default java.util.stream.Stream<T> stream(){ return null; }
    default void forEach(java.util.function.Consumer<? super T> p0){}
    org.jdbi.v3.core.result.ResultIterator<T> iterator();
    static <T> org.jdbi.v3.core.result.ResultIterable<T> of(Supplier<ResultSet> p0, org.jdbi.v3.core.mapper.RowMapper<T> p1, StatementContext p2){ return null; }
    static <T> org.jdbi.v3.core.result.ResultIterable<T> of(org.jdbi.v3.core.result.ResultIterator<T> p0){ return null; }
}
