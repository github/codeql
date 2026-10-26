// Generated automatically from org.apache.commons.collections4.MultiMap for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import org.apache.commons.collections4.IterableMap;

public interface MultiMap<K, V> extends IterableMap<K, Object>
{
    Collection<Object> values();
    Object get(Object p0);
    Object put(K p0, Object p1);
    Object remove(Object p0);
    boolean containsValue(Object p0);
    boolean removeMapping(K p0, V p1);
    int size();
}
