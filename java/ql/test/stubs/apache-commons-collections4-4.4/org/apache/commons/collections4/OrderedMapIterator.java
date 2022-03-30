// Generated automatically from org.apache.commons.collections4.OrderedMapIterator for testing purposes

package org.apache.commons.collections4;

import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.OrderedIterator;

public interface OrderedMapIterator<K, V> extends MapIterator<K, V>, OrderedIterator<K>
{
    K previous();
    boolean hasPrevious();
}
