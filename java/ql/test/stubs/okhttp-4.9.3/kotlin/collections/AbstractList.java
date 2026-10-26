// Generated automatically from kotlin.collections.AbstractList for testing purposes

package kotlin.collections;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import kotlin.collections.AbstractCollection;
import kotlin.jvm.internal.markers.KMappedMarker;

abstract public class AbstractList<E> extends AbstractCollection<E> implements KMappedMarker, List<E>
{
    protected AbstractList(){}
    public E remove(int p0){ return null; }
    public E set(int p0, E p1){ return null; }
    public Iterator<E> iterator(){ return null; }
    public List<E> subList(int p0, int p1){ return null; }
    public ListIterator<E> listIterator(){ return null; }
    public ListIterator<E> listIterator(int p0){ return null; }
    public abstract E get(int p0);
    public abstract int getSize();
    public boolean addAll(int p0, Collection<? extends E> p1){ return false; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public int indexOf(Object p0){ return 0; }
    public int lastIndexOf(Object p0){ return 0; }
    public static AbstractList.Companion Companion = null;
    public void add(int p0, E p1){}
    static public class Companion
    {
        protected Companion() {}
        public final boolean orderedEquals$kotlin_stdlib(Collection<? extends Object> p0, Collection<? extends Object> p1){ return false; }
        public final int orderedHashCode$kotlin_stdlib(Collection<? extends Object> p0){ return 0; }
        public final void checkBoundsIndexes$kotlin_stdlib(int p0, int p1, int p2){}
        public final void checkElementIndex$kotlin_stdlib(int p0, int p1){}
        public final void checkPositionIndex$kotlin_stdlib(int p0, int p1){}
        public final void checkRangeIndexes$kotlin_stdlib(int p0, int p1, int p2){}
    }
}
