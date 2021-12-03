// Generated automatically from org.apache.commons.collections4.SortedBidiMap for testing purposes

package org.apache.commons.collections4;

import java.util.Comparator;
import java.util.SortedMap;
import org.apache.commons.collections4.OrderedBidiMap;

public interface SortedBidiMap<K, V> extends OrderedBidiMap<K, V>, SortedMap<K, V>
{
    Comparator<? super V> valueComparator();
    SortedBidiMap<V, K> inverseBidiMap();
}
