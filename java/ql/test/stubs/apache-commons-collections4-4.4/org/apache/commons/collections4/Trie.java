// Generated automatically from org.apache.commons.collections4.Trie for testing purposes

package org.apache.commons.collections4;

import java.util.SortedMap;
import org.apache.commons.collections4.IterableSortedMap;

public interface Trie<K, V> extends IterableSortedMap<K, V>
{
    SortedMap<K, V> prefixMap(K p0);
}
