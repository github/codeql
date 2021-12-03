// Generated automatically from org.apache.commons.collections4.map.UnmodifiableEntrySet for testing purposes

package org.apache.commons.collections4.map;

import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.function.Predicate;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.set.AbstractSetDecorator;

public class UnmodifiableEntrySet<K, V> extends AbstractSetDecorator<Map.Entry<K, V>> implements Unmodifiable
{
    protected UnmodifiableEntrySet() {}
    public <T> T[] toArray(T[] p0){ return null; }
    public Iterator<Map.Entry<K, V>> iterator(){ return null; }
    public Object[] toArray(){ return null; }
    public boolean add(Map.Entry<K, V> p0){ return false; }
    public boolean addAll(Collection<? extends Map.Entry<K, V>> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super Map.Entry<K, V>> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <K, V> Set<Map.Entry<K, V>> unmodifiableEntrySet(Set<Map.Entry<K, V>> p0){ return null; }
    public void clear(){}
}
