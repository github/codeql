// Generated automatically from org.apache.commons.collections4.splitmap.TransformedSplitMap for testing purposes

package org.apache.commons.collections4.splitmap;

import java.io.Serializable;
import java.util.Map;
import org.apache.commons.collections4.Put;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.splitmap.AbstractIterableGetMapDecorator;

public class TransformedSplitMap<J, K, U, V> extends AbstractIterableGetMapDecorator<K, V> implements Put<J, U>, Serializable
{
    protected TransformedSplitMap() {}
    protected K transformKey(J p0){ return null; }
    protected Map<K, V> transformMap(Map<? extends J, ? extends U> p0){ return null; }
    protected TransformedSplitMap(Map<K, V> p0, Transformer<? super J, ? extends K> p1, Transformer<? super U, ? extends V> p2){}
    protected V checkSetValue(U p0){ return null; }
    protected V transformValue(U p0){ return null; }
    public V put(J p0, U p1){ return null; }
    public static <J, K, U, V> TransformedSplitMap<J, K, U, V> transformingMap(Map<K, V> p0, Transformer<? super J, ? extends K> p1, Transformer<? super U, ? extends V> p2){ return null; }
    public void clear(){}
    public void putAll(Map<? extends J, ? extends U> p0){}
}
