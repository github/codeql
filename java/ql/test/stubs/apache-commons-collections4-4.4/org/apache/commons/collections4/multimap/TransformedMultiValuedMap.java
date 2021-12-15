// Generated automatically from org.apache.commons.collections4.multimap.TransformedMultiValuedMap for testing purposes

package org.apache.commons.collections4.multimap;

import java.util.Map;
import org.apache.commons.collections4.MultiValuedMap;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.multimap.AbstractMultiValuedMapDecorator;

public class TransformedMultiValuedMap<K, V> extends AbstractMultiValuedMapDecorator<K, V>
{
    protected TransformedMultiValuedMap() {}
    protected K transformKey(K p0){ return null; }
    protected TransformedMultiValuedMap(MultiValuedMap<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){}
    protected V transformValue(V p0){ return null; }
    public boolean put(K p0, V p1){ return false; }
    public boolean putAll(K p0, Iterable<? extends V> p1){ return false; }
    public boolean putAll(Map<? extends K, ? extends V> p0){ return false; }
    public boolean putAll(MultiValuedMap<? extends K, ? extends V> p0){ return false; }
    public static <K, V> TransformedMultiValuedMap<K, V> transformedMap(MultiValuedMap<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){ return null; }
    public static <K, V> TransformedMultiValuedMap<K, V> transformingMap(MultiValuedMap<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){ return null; }
}
