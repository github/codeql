package p;

import java.util.*;
import java.util.function.*;
import java.util.stream.*;

public class Stream<T> {

    public Iterator<T> iterator() {
        return null;
    }

    public boolean allMatch(Predicate<? super T> predicate) {
        return false;
    }

    public <R> R collect(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner) {
        return null;
    }

    // Collector is not a functional interface, so this is not supported
    public <R, A> R collect(Collector<? super T, A, R> collector) {
        return null;
    }

    public static <T> Stream<T> concat(Stream<? extends T> a, Stream<? extends T> b) {
        return null;
    }

    public Stream<T> distinct() {
        return null;
    }

    public static <T> Stream<T> empty() {
        return null;
    }

    public Stream<T> filter(Predicate<? super T> predicate) {
        return null;
    }

    public Optional<T> findAny() {
        return null;
    }

    public Optional<T> findFirst() {
        return null;
    }

    // public <R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends
    // R>> mapper) {
    // return null;
    // }

    public DoubleStream flatMapToDouble(Function<? super T, ? extends DoubleStream> mapper) {
        return null;
    }

    public IntStream flatMapToInt(Function<? super T, ? extends IntStream> mapper) {
        return null;
    }

    public LongStream flatMapToLong(Function<? super T, ? extends LongStream> mapper) {
        return null;
    }

    public void forEach(Consumer<? super T> action) {
    }

    public void forEachOrdered(Consumer<? super T> action) {
    }

    public static <T> Stream<T> generate(Supplier<T> s) {
        return null;
    }

    // Model generator adds a couple of extra models, which can't be
    // dismissed based on the type information.
    public static <T> Stream<T> iterate(T seed, UnaryOperator<T> f) {
        return null;
    }

    public Stream<T> limit(long maxSize) {
        return null;
    }

    public <R> Stream<R> map(Function<? super T, ? extends R> mapper) {
        return null;
    }

    public DoubleStream mapToDouble(ToDoubleFunction<? super T> mapper) {
        return null;
    }

    public IntStream mapToInt(ToIntFunction<? super T> mapper) {
        return null;
    }

    public LongStream mapToLong(ToLongFunction<? super T> mapper) {
        return null;
    }

    public Optional<T> max(Comparator<? super T> comparator) {
        return null;
    }

    public Optional<T> min(Comparator<? super T> comparator) {
        return null;
    }

    public boolean noneMatch(Predicate<? super T> predicate) {
        return false;
    }

    // Issue with model generator. ... is not supported.
    // public static <T> Stream<T> of(T... t) {
    // return null;
    // }

    public static <T> Stream<T> of(T t) {
        return null;
    }

    public Stream<T> peek(Consumer<? super T> action) {
        return null;
    }

    // Model generator yields a couple of extra results as models are generated for
    // writing to the stream.
    public Optional<T> reduce(BinaryOperator<T> accumulator) {
        return null;
    }

    // Model generator yields a couple of extra results as models are generated for
    // writing to the stream.
    public T reduce(T identity, BinaryOperator<T> accumulator) {
        return null;
    }

    public <U> U reduce(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner) {
        return null;
    }

    public Stream<T> skip(long n) {
        return null;
    }

    public Stream<T> sorted() {
        return null;
    }

    public Stream<T> sorted(Comparator<? super T> comparator) {
        return null;
    }

    // Models can never be generated correctly based on the type information
    // as it involves downcasting.
    public Object[] toArray() {
        return null;
    }

    // Issue with model generator - no models are generated.
    // public <A> A[] toArray(IntFunction<A[]> generator) {
    // throw null;
    // }
}