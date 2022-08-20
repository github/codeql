// Generated automatically from org.apache.commons.collections4.OrderedBidiMap for testing purposes

package org.apache.commons.collections4;

import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.OrderedMap;

public interface OrderedBidiMap<K, V> extends BidiMap<K, V>, OrderedMap<K, V>
{
    OrderedBidiMap<V, K> inverseBidiMap();
}
