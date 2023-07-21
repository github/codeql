// Generated automatically from reactor.util.context.ContextView for testing purposes

package reactor.util.context;

import java.util.Map;
import java.util.Optional;
import java.util.function.BiConsumer;
import java.util.stream.Stream;

public interface ContextView
{
    <T> T get(Object p0);
    Stream<Map.Entry<Object, Object>> stream();
    boolean hasKey(Object p0);
    default <T> T get(java.lang.Class<T> p0){ return null; }
    default <T> T getOrDefault(Object p0, T p1){ return null; }
    default <T> java.util.Optional<T> getOrEmpty(Object p0){ return null; }
    default boolean isEmpty(){ return false; }
    default void forEach(BiConsumer<Object, Object> p0){}
    int size();
}
