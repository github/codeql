// Generated automatically from org.apache.commons.collections4.collection.UnmodifiableBoundedCollection for testing purposes

package org.apache.commons.collections4.collection;

import java.util.Collection;
import java.util.Iterator;
import java.util.function.Predicate;
import org.apache.commons.collections4.BoundedCollection;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.collection.AbstractCollectionDecorator;

public class UnmodifiableBoundedCollection<E> extends AbstractCollectionDecorator<E> implements BoundedCollection<E>, Unmodifiable
{
    protected UnmodifiableBoundedCollection() {}
    protected BoundedCollection<E> decorated(){ return null; }
    public Iterator<E> iterator(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean isFull(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int maxSize(){ return 0; }
    public static <E> BoundedCollection<E> unmodifiableBoundedCollection(BoundedCollection<? extends E> p0){ return null; }
    public static <E> BoundedCollection<E> unmodifiableBoundedCollection(Collection<? extends E> p0){ return null; }
    public void clear(){}
}
