// Generated automatically from org.apache.commons.collections4.SetValuedMap for testing purposes

package org.apache.commons.collections4;

import java.util.Set;
import org.apache.commons.collections4.MultiValuedMap;

public interface SetValuedMap<K, V> extends MultiValuedMap<K, V>
{
    Set<V> get(K p0);
    Set<V> remove(Object p0);
}
