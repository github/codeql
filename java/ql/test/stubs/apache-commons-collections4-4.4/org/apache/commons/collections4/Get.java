// Generated automatically from org.apache.commons.collections4.Get for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

public interface Get<K, V>
{
    Collection<V> values();
    Set<K> keySet();
    Set<Map.Entry<K, V>> entrySet();
    V get(Object p0);
    V remove(Object p0);
    boolean containsKey(Object p0);
    boolean containsValue(Object p0);
    boolean isEmpty();
    int size();
}
