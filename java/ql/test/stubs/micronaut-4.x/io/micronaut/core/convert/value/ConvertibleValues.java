package io.micronaut.core.convert.value;

import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

public interface ConvertibleValues<V> extends Iterable<Map.Entry<String, V>> {
    Map<String, V> asMap();
    Properties asProperties();
    V getValue(CharSequence name);
    Iterator<Map.Entry<String, V>> iterator();
    Map<String, V> subMap(String prefix, Class<?> valueType);
    Collection<V> values();
}
