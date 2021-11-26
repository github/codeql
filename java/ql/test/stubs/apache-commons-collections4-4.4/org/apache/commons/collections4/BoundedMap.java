// Generated automatically from org.apache.commons.collections4.BoundedMap for testing purposes

package org.apache.commons.collections4;

import org.apache.commons.collections4.IterableMap;

public interface BoundedMap<K, V> extends IterableMap<K, V>
{
    boolean isFull();
    int maxSize();
}
