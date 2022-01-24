// Generated automatically from org.apache.commons.collections4.map.AbstractInputCheckedMapDecorator for testing purposes

package org.apache.commons.collections4.map;

import java.util.Map;
import java.util.Set;
import org.apache.commons.collections4.map.AbstractMapDecorator;

abstract class AbstractInputCheckedMapDecorator<K, V> extends AbstractMapDecorator<K, V>
{
    protected AbstractInputCheckedMapDecorator(){}
    protected AbstractInputCheckedMapDecorator(Map<K, V> p0){}
    protected abstract V checkSetValue(V p0);
    protected boolean isSetValueChecking(){ return false; }
    public Set<Map.Entry<K, V>> entrySet(){ return null; }
}
