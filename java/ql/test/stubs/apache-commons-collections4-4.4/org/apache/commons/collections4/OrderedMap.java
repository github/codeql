// Generated automatically from org.apache.commons.collections4.OrderedMap for testing purposes

package org.apache.commons.collections4;

import org.apache.commons.collections4.IterableMap;
import org.apache.commons.collections4.OrderedMapIterator;

public interface OrderedMap<K, V> extends IterableMap<K, V>
{
    K firstKey();
    K lastKey();
    K nextKey(K p0);
    K previousKey(K p0);
    OrderedMapIterator<K, V> mapIterator();
}
