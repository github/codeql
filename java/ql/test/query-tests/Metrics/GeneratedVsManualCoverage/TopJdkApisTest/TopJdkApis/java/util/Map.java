// Generated automatically from java.util.Map for testing purposes

package java.util;

import java.util.Collection;
import java.util.Comparator;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;

public interface Map<K, V>
{
    V get(Object p0); // manual summary
    V put(K p0, V p1); // manual summary
    V remove(Object p0); // manual summary
    boolean containsKey(Object p0); // manual neutral
    boolean isEmpty(); // manual neutral
    default V computeIfAbsent(K p0, java.util.function.Function<? super K, ? extends V> p1){ return null; } // manual summary
    default V getOrDefault(Object p0, V p1){ return null; } // manual summary
    default void forEach(java.util.function.BiConsumer<? super K, ? super V> p0){} // manual summary
    int size(); // manual neutral
    java.util.Collection<V> values(); // manual summary
    java.util.Set<K> keySet(); // manual summary
    java.util.Set<Map.Entry<K, V>> entrySet(); // manual summary
    void clear(); // manual neutral
    void putAll(java.util.Map<? extends K, ? extends V> p0); // manual summary

    static <K, V> Map.Entry<K, V> entry(K k, V v) { return null; }  // manual summary
    static <K, V> Map<K, V> of(K k1, V v1) { return null; }  // manual summary
    static <K, V> Map<K, V> of(K k1, V v1, K k2, V v2) { return null; }  // manual summary

    interface Entry<K, V> {
        K getKey(); // manual summary
        V getValue(); // manual summary
    }
}
