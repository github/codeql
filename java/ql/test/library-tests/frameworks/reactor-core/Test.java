import java.util.Optional;
import reactor.core.publisher.Mono;

public class Test {

    void sink(Object o) {}

    String taint() {
        return null;
    }

    void testJust() {
        Mono<String> unsafe = Mono.just(taint());
        unsafe.map(value -> {
            sink(value); // $ hasValueFlow
            return value;
        });
        Mono<String> safe = Mono.just("safe");
        safe.map(value -> {
            sink(value); // no taint flow
            return value;
        });
    }

    void testJustOrEmpty() {
        Mono<String> unsafe = Mono.justOrEmpty(taint());
        unsafe.map(value -> {
            sink(value); // $ hasValueFlow
            return value;
        });
        Mono<String> safe = Mono.justOrEmpty("safe");
        safe.map(value -> {
            sink(value); // no taint flow
            return value;
        });
    }

    void testJustOrEmptyOptional() {
        Mono<String> unsafe = Mono.justOrEmpty(Optional.of(taint()));
        unsafe.map(value -> {
            sink(value); // $ hasValueFlow
            return value;
        });
        Mono<String> safe = Mono.justOrEmpty(Optional.of("safe"));
        safe.map(value -> {
            sink(value); // no taint flow
            return value;
        });
        Mono<String> empty = Mono.justOrEmpty(Optional.<String>empty());
        empty.map(value -> {
            sink(value); // no taint flow
            return value;
        });
    }

    void testFlatMap() {
        Mono.just(taint()).flatMap(value -> {
            sink(value); // $ hasValueFlow
            return Mono.just("safe");
        });
        Mono.just("safe").flatMap(value -> {
            sink(value); // no taint flow
            return Mono.just("safe");
        });
    }

    void testMap() {
        Mono.just(taint()).map(value -> {
            sink(value); // $ hasValueFlow
            return "safe";
        });
        Mono.just("safe").map(value -> {
            sink(value); // no taint flow
            return "safe";
        });
    }

    void testMapNotNull() {
        Mono.just(taint()).mapNotNull(value -> {
            sink(value); // $ hasValueFlow
            return "safe";
        });
        Mono.just("safe").mapNotNull(value -> {
            sink(value); // no taint flow
            return "safe";
        });
    }

    void testFlatMapResult() {
        Mono.just("safe").flatMap(value -> Mono.just(taint())).map(value -> {
            sink(value); // $ hasValueFlow
            return value;
        });
        Mono.just(taint()).flatMap(value -> Mono.just("safe")).map(value -> {
            sink(value); // no taint flow
            return value;
        });
    }

    void testMapResult() {
        Mono.just("safe").map(value -> taint()).map(value -> {
            sink(value); // $ hasValueFlow
            return value;
        });
        Mono.just(taint()).map(value -> "safe").map(value -> {
            sink(value); // no taint flow
            return value;
        });
    }

    void testMapNotNullResult() {
        Mono.just("safe").mapNotNull(value -> taint()).map(value -> {
            sink(value); // $ hasValueFlow
            return value;
        });
        Mono.just(taint()).mapNotNull(value -> "safe").map(value -> {
            sink(value); // no taint flow
            return value;
        });
    }

    void testNestedValues() {
        Mono.just(Optional.of(taint())).flatMap(value -> {
            sink(value.get()); // $ hasValueFlow
            return Mono.just("safe");
        });
        Mono.just(Optional.of(taint())).map(value -> {
            sink(value.get()); // $ hasValueFlow
            return "safe";
        });
        Mono.just(Optional.of(taint())).mapNotNull(value -> {
            sink(value.get()); // $ hasValueFlow
            return "safe";
        });
    }
}