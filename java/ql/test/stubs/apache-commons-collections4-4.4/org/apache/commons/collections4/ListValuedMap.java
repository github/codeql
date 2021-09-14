// Generated automatically from org.apache.commons.collections4.ListValuedMap for testing purposes

package org.apache.commons.collections4;

import java.util.List;
import org.apache.commons.collections4.MultiValuedMap;

public interface ListValuedMap<K, V> extends MultiValuedMap<K, V>
{
    List<V> get(K p0);
    List<V> remove(Object p0);
}
