package p;

import java.util.*;
import java.util.function.*;
import java.util.stream.*;

public class Stream<T> {

    public Iterator<T> iterator() {
        return null;
    }

    public boolean allMatch(Predicate<? super T> predicate) {
        throw null;
    }

    public <R> R collect(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner) {
        throw null;
    }

    // Collector is not a functional interface, so this is not supported
    public <R, A> R collect(Collector<? super T, A, R> collector) {
        throw null;
    }

    public static <T> Stream<T> concat(Stream<? extends T> a, Stream<? extends T> b) {
        throw null;
    }

    public Stream<T> distinct() {
        throw null;
    }

    public static <T> Stream<T> empty() {
        throw null;
    }

    public Stream<T> filter(Predicate<? super T> predicate) {
        throw null;
    }

    public Optional<T> findAny() {
        throw null;
    }

    public Optional<T> findFirst() {
        throw null;
    }

    // public <R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends
    // R>> mapper) {
    // throw null;
    // }

    public DoubleStream flatMapToDouble(Function<? super T, ? extends DoubleStream> mapper) {
        throw null;
    }

    public IntStream flatMapToInt(Function<? super T, ? extends IntStream> mapper) {
        throw null;
    }

    public LongStream flatMapToLong(Function<? super T, ? extends LongStream> mapper) {
        throw null;
    }

    public void forEach(Consumer<? super T> action) {
        throw null;
    }

    public void forEachOrdered(Consumer<? super T> action) {
        throw null;
    }

    public static <T> Stream<T> generate(Supplier<T> s) {
        throw null;
    }

    // Model generator adds a couple of extra models, which can't be
    // dismissed based on the type information.
    public static <T> Stream<T> iterate(T seed, UnaryOperator<T> f) {
        throw null;
    }

    public Stream<T> limit(long maxSize) {
        throw null;
    }

    public <R> Stream<R> map(Function<? super T, ? extends R> mapper) {
        throw null;
    }

    public DoubleStream mapToDouble(ToDoubleFunction<? super T> mapper) {
        throw null;
    }

    public IntStream mapToInt(ToIntFunction<? super T> mapper) {
        throw null;
    }

    public LongStream mapToLong(ToLongFunction<? super T> mapper) {
        throw null;
    }

    public Optional<T> max(Comparator<? super T> comparator) {
        throw null;
    }

    public Optional<T> min(Comparator<? super T> comparator) {
        throw null;
    }

    public boolean noneMatch(Predicate<? super T> predicate) {
        throw null;
    }

    // Issue with model generator. ... is not supported.
    // public static <T> Stream<T> of(T... t) {
    // throw null;
    // }

    public static <T> Stream<T> of(T t) {
        throw null;
    }

    public Stream<T> peek(Consumer<? super T> action) {
        throw null;
    }

    // Model generator yields a couple of extra results as models are generated for
    // writing to the stream.
    public Optional<T> reduce(BinaryOperator<T> accumulator) {
        throw null;
    }

    // Model generator yields a couple of extra results as models are generated for
    // writing to the stream.
    public T reduce(T identity, BinaryOperator<T> accumulator) {
        throw null;
    }

    public <U> U reduce(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner) {
        throw null;
    }

    public Stream<T> skip(long n) {
        throw null;
    }

    public Stream<T> sorted() {
        throw null;
    }

    public Stream<T> sorted(Comparator<? super T> comparator) {
        throw null;
    }

    // Models can never be generated correctly based on the type information
    // as it involves downcasting.
    public Object[] toArray() {
        throw null;
    }

    // Issue with model generator - no models are generated.
    // public <A> A[] toArray(IntFunction<A[]> generator) {
    // throw null;
    // }
}