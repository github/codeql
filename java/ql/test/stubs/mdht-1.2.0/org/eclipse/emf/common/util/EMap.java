// Generated automatically from org.eclipse.emf.common.util.EMap for testing purposes

package org.eclipse.emf.common.util;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.eclipse.emf.common.util.EList;

public interface EMap<K, V> extends EList<Map.Entry<K, V>>
{
    V get(Object p0);
    V put(K p0, V p1);
    V removeKey(Object p0);
    boolean containsKey(Object p0);
    boolean containsValue(Object p0);
    int indexOfKey(Object p0);
    java.util.Collection<V> values();
    java.util.Map<K, V> map();
    java.util.Set<K> keySet();
    java.util.Set<Map.Entry<K, V>> entrySet();
    void putAll(EMap<? extends K, ? extends V> p0);
    void putAll(java.util.Map<? extends K, ? extends V> p0);
}
