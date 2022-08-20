// Generated automatically from org.apache.commons.collections4.set.CompositeSet for testing purposes

package org.apache.commons.collections4.set;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.function.Predicate;

public class CompositeSet<E> implements Serializable, Set<E>
{
    protected CompositeSet.SetMutator<E> getMutator(){ return null; }
    public <T> T[] toArray(T[] p0){ return null; }
    public CompositeSet(){}
    public CompositeSet(Set<E> p0){}
    public CompositeSet(Set<E>... p0){}
    public Iterator<E> iterator(){ return null; }
    public List<Set<E>> getSets(){ return null; }
    public Object[] toArray(){ return null; }
    public Set<E> toSet(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public void addComposited(Set<E> p0){}
    public void addComposited(Set<E> p0, Set<E> p1){}
    public void addComposited(Set<E>... p0){}
    public void clear(){}
    public void removeComposited(Set<E> p0){}
    public void setMutator(CompositeSet.SetMutator<E> p0){}
    static public interface SetMutator<E> extends Serializable
    {
        boolean add(CompositeSet<E> p0, List<Set<E>> p1, E p2);
        boolean addAll(CompositeSet<E> p0, List<Set<E>> p1, Collection<? extends E> p2);
        void resolveCollision(CompositeSet<E> p0, Set<E> p1, Set<E> p2, Collection<E> p3);
    }
}
