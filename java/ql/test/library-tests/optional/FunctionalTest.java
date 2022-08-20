import java.util.Optional;

public class FunctionalTest {
    String source() {
        return null;
    }

    void sink(Object o) {
    }

    void test() {
        Optional<String> o = Optional.of(source());
        o.ifPresent(v -> {
            sink(v); // $hasValueFlow
        });
        o.ifPresentOrElse(v -> {
            sink(v); // $hasValueFlow
        }, () -> {
            // no-op
        });
        o.map(v -> {
            sink(v); // $hasValueFlow
            return v;
        }).ifPresent(v -> {
            sink(v); // $hasValueFlow
        });
        o.flatMap(v -> {
            sink(v); // $hasValueFlow
            return Optional.of(v);
        }).ifPresent(v -> {
            sink(v); // $hasValueFlow
        });
        o.flatMap(v -> {
            sink(v); // $hasValueFlow
            return Optional.of("safe");
        }).ifPresent(v -> {
            sink(v); // no value flow
        });
        o.filter(v -> {
            sink(v); // $hasValueFlow
            return true;
        }).ifPresent(v -> {
            sink(v); // $hasValueFlow
        });
        Optional.of("safe").map(v -> {
            sink(v); // no value flow
            return v;
        }).or(() -> o).ifPresent(v -> {
            sink(v); // $hasValueFlow
        });
        Optional<String> safe = Optional.of("safe");
        o.or(() -> safe).ifPresent(v -> {
            sink(v); // $hasValueFlow
        });
        String value = safe.orElseGet(() -> source());
        sink(value); // $hasValueFlow
    }
}
