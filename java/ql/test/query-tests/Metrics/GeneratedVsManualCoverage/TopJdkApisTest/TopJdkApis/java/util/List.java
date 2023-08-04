// Generated automatically from java.util.List for testing purposes

package java.util;

import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.Spliterator;
import java.util.function.UnaryOperator;

public interface List<E> extends java.util.Collection<E>
{
    <T> T[] toArray(T[] p0); // manual summary
    E get(int p0); // manual summary
    E remove(int p0); // manual summary
    E set(int p0, E p1); // manual summary
    List<E> subList(int p0, int p1); // manual summary
    Object[] toArray(); // manual summary
    boolean add(E p0); // manual summary
    boolean addAll(java.util.Collection<? extends E> p0); // manual summary
    boolean contains(Object p0); // manual neutral
    boolean equals(Object p0); // manual neutral
    boolean isEmpty(); // manual neutral
    boolean remove(Object p0); // manual neutral
    default void sort(java.util.Comparator<? super E> p0){} // manual neutral
    int hashCode(); // manual neutral
    int indexOf(Object p0); // manual neutral
    int size(); // manual neutral
    java.util.Iterator<E> iterator(); // manual summary
    void add(int p0, E p1); // manual summary
    void clear(); // manual neutral

    static <E> List<E> of() { return null; } // manual neutral
    static <E> List<E> of(E e1) { return null; } // manual summary
    static <E> List<E> of(E e1, E e2) { return null; } // manual summary
    static <E> List<E> of(E e1, E e2, E e3) { return null; } // manual summary
}
