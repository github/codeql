package p;

import java.util.function.*;
import java.util.Iterator;
import java.util.stream.Collector;

public class Stream<T> {

    public Iterator<T> iterator() {
        return null;
    }

    // public boolean allMatch(Predicate<? super T> predicate) {
    // throw null;
    // }

    // public <R> R collect(Supplier<R> supplier, BiConsumer<R, ? super T>
    // accumulator, BiConsumer<R, R> combiner) {
    // throw null;
    // }

    // public <R, A> R collect(Collector<? super T, A, R> collector) {
    // throw null;
    // }

    // public static <T> Stream<T> concat(Stream<? extends T> a, Stream<? extends T>
    // b) {
    // throw null;
    // }

    public Stream<T> distinct() {
        throw null;
    }
}