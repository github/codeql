package io.micronaut.core.convert.value;

import java.util.List;
import java.util.Optional;

public interface ConvertibleMultiValues<V> extends ConvertibleValues<List<V>> {
    V get(CharSequence name);
    List<V> getAll(CharSequence name);
    Optional<V> getFirst(CharSequence name);
}
