package io.micronaut.http;

import java.util.List;
import java.util.Optional;

public interface HttpHeaders {
    String get(CharSequence name);
    List<String> getAll(CharSequence name);
    Optional<String> getFirst(CharSequence name);
    java.util.Collection<List<String>> values();
}
