// Generated automatically from org.apache.commons.collections4.BidiMap for testing purposes

package org.apache.commons.collections4;

import java.util.Set;
import org.apache.commons.collections4.IterableMap;

public interface BidiMap<K, V> extends IterableMap<K, V>
{
    BidiMap<V, K> inverseBidiMap();
    K getKey(Object p0);
    K removeValue(Object p0);
    Set<V> values();
    V put(K p0, V p1);
}
