// Generated automatically from java.util.Set for testing purposes

package java.util;

import java.util.Collection;
import java.util.Iterator;
import java.util.Spliterator;

public interface Set<E> extends java.util.Collection<E>
{
    boolean add(E p0); // manual summary
    boolean addAll(java.util.Collection<? extends E> p0); // manual summary
    boolean contains(Object p0); // manual neutral
    boolean isEmpty(); // manual neutral
    boolean remove(Object p0); // manual neutral
    boolean removeAll(Collection<? extends Object> p0); // manual neutral
    int size(); // manual neutral
    java.util.Iterator<E> iterator(); // manual summary
    void clear(); // manual neutral

    static <E> Set<E> of(E e1) { return null; } // manual summary
    static <E> Set<E> of(E e1, E e2) { return null; } // manual summary
}
