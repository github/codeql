// Generated automatically from org.apache.commons.collections4.set.UnmodifiableSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.function.Predicate;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.set.AbstractSerializableSetDecorator;

public class UnmodifiableSet<E> extends AbstractSerializableSetDecorator<E> implements Unmodifiable
{
    protected UnmodifiableSet() {}
    public Iterator<E> iterator(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <E> Set<E> unmodifiableSet(Set<? extends E> p0){ return null; }
    public void clear(){}
}
