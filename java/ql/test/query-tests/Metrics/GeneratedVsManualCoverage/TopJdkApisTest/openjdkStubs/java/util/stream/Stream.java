// Generated automatically from java.util.stream.Stream for testing purposes

package java.util.stream;

import java.util.Comparator;
import java.util.Optional;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.IntFunction;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;
import java.util.function.UnaryOperator;
import java.util.stream.BaseStream;
import java.util.stream.Collector;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;

public interface Stream<T> extends BaseStream<T, Stream<T>>
{
    <A> A[] toArray(IntFunction<A[]> p0); // manual summary
    <R, A> R collect(Collector<? super T, A, R> p0); // NOT MODELED
    <R> java.util.stream.Stream<R> flatMap(Function<? super T, ? extends Stream<? extends R>> p0); // manual summary
    <R> java.util.stream.Stream<R> map(Function<? super T, ? extends R> p0); // manual summary
    IntStream mapToInt(java.util.function.ToIntFunction<? super T> p0); // manual summary
    Stream<T> distinct(); // manual summary
    Stream<T> filter(java.util.function.Predicate<? super T> p0); // manual summary
    Stream<T> sorted(); // manual summary
    Stream<T> sorted(java.util.Comparator<? super T> p0); // manual summary
    T reduce(T p0, java.util.function.BinaryOperator<T> p1); // manual summary
    boolean allMatch(java.util.function.Predicate<? super T> p0); // manual summary
    boolean anyMatch(java.util.function.Predicate<? super T> p0); // manual summary
    java.util.Optional<T> findAny(); // manual summary
    java.util.Optional<T> findFirst(); // manual summary
    long count(); // manual neutral
    static <T> java.util.stream.Stream<T> concat(Stream<? extends T> p0, Stream<? extends T> p1){ return null; } // manual summary
    static <T> java.util.stream.Stream<T> of(T p0){ return null; } // manual summary
    static <T> java.util.stream.Stream<T> of(T... p0){ return null; } // manual summary
    void forEach(java.util.function.Consumer<? super T> p0); // manual summary

    default java.util.List<T> toList() { return null; } // manual summary
}
