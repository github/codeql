package io.micronaut.http.cookie;

import java.util.Collection;
import java.util.Optional;
import java.util.Set;

public interface Cookies {
    Set<Cookie> getAll();
    Optional<Cookie> findCookie(CharSequence name);
    Cookie get(CharSequence name);
}
