package reactor.core.publisher;

import java.util.Optional;
import java.util.function.Function;

public abstract class Mono<T> {
    public static <T> Mono<T> just(T value) {
        return null;
    }

    public static <T> Mono<T> justOrEmpty(T value) {
        return null;
    }

    public static <T> Mono<T> justOrEmpty(Optional<? extends T> value) {
        return null;
    }

    public final <R> Mono<R> flatMap(Function<? super T, ? extends Mono<? extends R>> mapper) {
        return null;
    }

    public final <R> Mono<R> map(Function<? super T, ? extends R> mapper) {
        return null;
    }

    public final <R> Mono<R> mapNotNull(Function<? super T, ? extends R> mapper) {
        return null;
    }
}
