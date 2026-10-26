// Generated automatically from org.apache.commons.collections4.collection.UnmodifiableCollection for testing purposes

package org.apache.commons.collections4.collection;

import java.util.Collection;
import java.util.Iterator;
import java.util.function.Predicate;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.collection.AbstractCollectionDecorator;

public class UnmodifiableCollection<E> extends AbstractCollectionDecorator<E> implements Unmodifiable
{
    protected UnmodifiableCollection() {}
    public Iterator<E> iterator(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <T> Collection<T> unmodifiableCollection(Collection<? extends T> p0){ return null; }
    public void clear(){}
}
