// Generated automatically from org.apache.commons.collections4.map.PredicatedMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.Serializable;
import java.util.Map;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.map.AbstractInputCheckedMapDecorator;

public class PredicatedMap<K, V> extends AbstractInputCheckedMapDecorator<K, V> implements Serializable
{
    protected PredicatedMap() {}
    protected PredicatedMap(Map<K, V> p0, Predicate<? super K> p1, Predicate<? super V> p2){}
    protected V checkSetValue(V p0){ return null; }
    protected boolean isSetValueChecking(){ return false; }
    protected final Predicate<? super K> keyPredicate = null;
    protected final Predicate<? super V> valuePredicate = null;
    protected void validate(K p0, V p1){}
    public V put(K p0, V p1){ return null; }
    public static <K, V> PredicatedMap<K, V> predicatedMap(Map<K, V> p0, Predicate<? super K> p1, Predicate<? super V> p2){ return null; }
    public void putAll(Map<? extends K, ? extends V> p0){}
}
