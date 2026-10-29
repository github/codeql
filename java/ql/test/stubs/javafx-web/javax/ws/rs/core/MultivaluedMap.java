// Generated automatically from javax.ws.rs.core.MultivaluedMap for testing purposes

package javax.ws.rs.core;

import java.util.List;
import java.util.Map;

public interface MultivaluedMap<K, V> extends java.util.Map<K, java.util.List<V>>
{
    V getFirst(K p0);
    boolean equalsIgnoreValueOrder(MultivaluedMap<K, V> p0);
    void add(K p0, V p1);
    void addAll(K p0, V... p1);
    void addAll(K p0, java.util.List<V> p1);
    void addFirst(K p0, V p1);
    void putSingle(K p0, V p1);
}
