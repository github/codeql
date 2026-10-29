// Generated automatically from com.mitchellbosecke.pebble.cache.PebbleCache for testing purposes

package com.mitchellbosecke.pebble.cache;

import java.util.function.Function;

public interface PebbleCache<K, V>
{
    V computeIfAbsent(K p0, Function<? super K, ? extends V> p1);
    void invalidateAll();
}
