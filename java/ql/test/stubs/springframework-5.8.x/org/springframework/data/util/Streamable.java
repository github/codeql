// Generated automatically from org.springframework.data.util.Streamable for testing purposes

package org.springframework.data.util;

import java.util.List;
import java.util.Set;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.stream.Collector;
import java.util.stream.Stream;

public interface Streamable<T> extends Iterable<T>, Supplier<Stream<T>>
{
    default <R> Streamable<R> flatMap(Function<? super T, ? extends Stream<? extends R>> p0){ return null; }
    default <R> Streamable<R> map(Function<? super T, ? extends R> p0){ return null; }
    default List<T> toList(){ return null; }
    default Set<T> toSet(){ return null; }
    default Stream<T> get(){ return null; }
    default Stream<T> stream(){ return null; }
    default Streamable<T> and(Iterable<? extends T> p0){ return null; }
    default Streamable<T> and(Streamable<? extends T> p0){ return null; }
    default Streamable<T> and(Supplier<? extends Stream<? extends T>> p0){ return null; }
    default Streamable<T> and(T... p0){ return null; }
    default Streamable<T> filter(Predicate<? super T> p0){ return null; }
    default boolean isEmpty(){ return false; }
    static <S, T extends Iterable<S>> Collector<S, ? extends Object, Streamable<S>> toStreamable(Collector<S, ? extends Object, T> p0){ return null; }
    static <S> Collector<S, ? extends Object, Streamable<S>> toStreamable(){ return null; }
    static <T> Streamable<T> empty(){ return null; }
    static <T> Streamable<T> of(Iterable<T> p0){ return null; }
    static <T> Streamable<T> of(Supplier<? extends Stream<T>> p0){ return null; }
    static <T> Streamable<T> of(T... p0){ return null; }
}
