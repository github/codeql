// Generated automatically from org.apache.commons.collections4.keyvalue.UnmodifiableMapEntry for testing purposes

package org.apache.commons.collections4.keyvalue;

import java.util.Map;
import org.apache.commons.collections4.KeyValue;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.keyvalue.AbstractMapEntry;

public class UnmodifiableMapEntry<K, V> extends AbstractMapEntry<K, V> implements Unmodifiable
{
    protected UnmodifiableMapEntry() {}
    public UnmodifiableMapEntry(K p0, V p1){}
    public UnmodifiableMapEntry(KeyValue<? extends K, ? extends V> p0){}
    public UnmodifiableMapEntry(Map.Entry<? extends K, ? extends V> p0){}
    public V setValue(V p0){ return null; }
}
