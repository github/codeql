// Generated automatically from org.apache.commons.collections4.map.LazyMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Map;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.map.AbstractMapDecorator;

public class LazyMap<K, V> extends AbstractMapDecorator<K, V> implements Serializable
{
    protected LazyMap() {}
    protected LazyMap(Map<K, V> p0, Factory<? extends V> p1){}
    protected LazyMap(Map<K, V> p0, Transformer<? super K, ? extends V> p1){}
    protected final Transformer<? super K, ? extends V> factory = null;
    public V get(Object p0){ return null; }
    public static <K, V> LazyMap<K, V> lazyMap(Map<K, V> p0, Factory<? extends V> p1){ return null; }
    public static <V, K> LazyMap<K, V> lazyMap(Map<K, V> p0, Transformer<? super K, ? extends V> p1){ return null; }
}
