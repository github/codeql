package io.micronaut.http.cookie;

import io.micronaut.core.convert.value.ConvertibleValues;
import java.util.Optional;
import java.util.Set;

public interface Cookies extends ConvertibleValues<Cookie> {
    Set<Cookie> getAll();
    Optional<Cookie> findCookie(CharSequence name);
    Cookie get(CharSequence name);
}
