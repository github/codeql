// Generated automatically from org.apache.commons.collections4.bidimap.DualLinkedHashBidiMap for testing purposes

package org.apache.commons.collections4.bidimap;

import java.io.Serializable;
import java.util.Map;
import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.bidimap.AbstractDualBidiMap;

public class DualLinkedHashBidiMap<K, V> extends AbstractDualBidiMap<K, V> implements Serializable
{
    protected BidiMap<V, K> createBidiMap(Map<V, K> p0, Map<K, V> p1, BidiMap<K, V> p2){ return null; }
    protected DualLinkedHashBidiMap(Map<K, V> p0, Map<V, K> p1, BidiMap<V, K> p2){}
    public DualLinkedHashBidiMap(){}
    public DualLinkedHashBidiMap(Map<? extends K, ? extends V> p0){}
}
