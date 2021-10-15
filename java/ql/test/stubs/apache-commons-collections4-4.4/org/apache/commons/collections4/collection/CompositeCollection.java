// Generated automatically from org.apache.commons.collections4.collection.CompositeCollection for testing purposes

package org.apache.commons.collections4.collection;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.function.Predicate;

public class CompositeCollection<E> implements Collection<E>, Serializable
{
    protected CompositeCollection.CollectionMutator<E> getMutator(){ return null; }
    public <T> T[] toArray(T[] p0){ return null; }
    public Collection<E> toCollection(){ return null; }
    public CompositeCollection(){}
    public CompositeCollection(Collection<E> p0){}
    public CompositeCollection(Collection<E> p0, Collection<E> p1){}
    public CompositeCollection(Collection<E>... p0){}
    public Iterator<E> iterator(){ return null; }
    public List<Collection<E>> getCollections(){ return null; }
    public Object[] toArray(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int size(){ return 0; }
    public void addComposited(Collection<E> p0){}
    public void addComposited(Collection<E> p0, Collection<E> p1){}
    public void addComposited(Collection<E>... p0){}
    public void clear(){}
    public void removeComposited(Collection<E> p0){}
    public void setMutator(CompositeCollection.CollectionMutator<E> p0){}
    static public interface CollectionMutator<E> extends Serializable
    {
        boolean add(CompositeCollection<E> p0, List<Collection<E>> p1, E p2);
        boolean addAll(CompositeCollection<E> p0, List<Collection<E>> p1, Collection<? extends E> p2);
        boolean remove(CompositeCollection<E> p0, List<Collection<E>> p1, Object p2);
    }
}
