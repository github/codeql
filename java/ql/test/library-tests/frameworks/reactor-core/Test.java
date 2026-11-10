import java.util.Optional;
import reactor.core.publisher.Mono;

public class Test {

    void sink(Object o) {}

    String taint() {
        return null;
    }

    void testJust() {
        Mono<String> unsafe = Mono.just(taint());
        sink(unsafe); // $ hasTaintFlow
        Mono<String> safe = Mono.just("safe");
        sink(safe); // no taint flow
    }

    void testJustOrEmpty() {
        Mono<String> unsafe = Mono.justOrEmpty(taint());
        sink(unsafe); // $ hasTaintFlow
        Mono<String> safe = Mono.justOrEmpty("safe");
        sink(safe); // no taint flow
    }

    void testJustOrEmptyOptional() {
        Mono<String> unsafe = Mono.justOrEmpty(Optional.of(taint()));
        sink(unsafe); // $ hasTaintFlow
        Mono<String> safe = Mono.justOrEmpty(Optional.of("safe"));
        sink(safe); // no taint flow
        Mono<String> empty = Mono.justOrEmpty(Optional.<String>empty());
        sink(empty); // no taint flow
    }

    void testFlatMap() {
        Mono.just(taint()).flatMap(value -> {
            sink(value); // $ hasTaintFlow
            return Mono.just("safe");
        });
        Mono.just("safe").flatMap(value -> {
            sink(value); // no taint flow
            return Mono.just("safe");
        });
    }

    void testMap() {
        Mono.just(taint()).map(value -> {
            sink(value); // $ hasTaintFlow
            return "safe";
        });
        Mono.just("safe").map(value -> {
            sink(value); // no taint flow
            return "safe";
        });
    }

    void testMapNotNull() {
        Mono.just(taint()).mapNotNull(value -> {
            sink(value); // $ hasTaintFlow
            return "safe";
        });
        Mono.just("safe").mapNotNull(value -> {
            sink(value); // no taint flow
            return "safe";
        });
    }
}