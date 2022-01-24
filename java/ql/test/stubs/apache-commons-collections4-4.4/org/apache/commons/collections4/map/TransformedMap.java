// Generated automatically from org.apache.commons.collections4.map.TransformedMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Map;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.map.AbstractInputCheckedMapDecorator;

public class TransformedMap<K, V> extends AbstractInputCheckedMapDecorator<K, V> implements Serializable
{
    protected TransformedMap() {}
    protected K transformKey(K p0){ return null; }
    protected Map<K, V> transformMap(Map<? extends K, ? extends V> p0){ return null; }
    protected TransformedMap(Map<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){}
    protected V checkSetValue(V p0){ return null; }
    protected V transformValue(V p0){ return null; }
    protected boolean isSetValueChecking(){ return false; }
    protected final Transformer<? super K, ? extends K> keyTransformer = null;
    protected final Transformer<? super V, ? extends V> valueTransformer = null;
    public V put(K p0, V p1){ return null; }
    public static <K, V> TransformedMap<K, V> transformedMap(Map<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){ return null; }
    public static <K, V> TransformedMap<K, V> transformingMap(Map<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){ return null; }
    public void putAll(Map<? extends K, ? extends V> p0){}
}
