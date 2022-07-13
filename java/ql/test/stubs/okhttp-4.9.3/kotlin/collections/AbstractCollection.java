// Generated automatically from kotlin.collections.AbstractCollection for testing purposes

package kotlin.collections;

import java.util.Collection;
import java.util.Iterator;
import kotlin.jvm.internal.markers.KMappedMarker;

abstract public class AbstractCollection<E> implements Collection<E>, KMappedMarker
{
    protected AbstractCollection(){}
    public <T> T[] toArray(T[] p0){ return null; }
    public Object[] toArray(){ return null; }
    public String toString(){ return null; }
    public abstract Iterator<E> iterator();
    public abstract int getSize();
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public void clear(){}
}
