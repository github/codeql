// Generated automatically from org.apache.commons.collections4.map.DefaultedMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Map;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.map.AbstractMapDecorator;

public class DefaultedMap<K, V> extends AbstractMapDecorator<K, V> implements Serializable
{
    protected DefaultedMap() {}
    protected DefaultedMap(Map<K, V> p0, Transformer<? super K, ? extends V> p1){}
    public DefaultedMap(Transformer<? super K, ? extends V> p0){}
    public DefaultedMap(V p0){}
    public V get(Object p0){ return null; }
    public static <K, V> DefaultedMap<K, V> defaultedMap(Map<K, V> p0, Factory<? extends V> p1){ return null; }
    public static <K, V> DefaultedMap<K, V> defaultedMap(Map<K, V> p0, V p1){ return null; }
    public static <K, V> Map<K, V> defaultedMap(Map<K, V> p0, Transformer<? super K, ? extends V> p1){ return null; }
}
