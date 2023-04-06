// Generated automatically from java.util.Collection for testing purposes

package java.util;

import java.util.Iterator;
import java.util.Spliterator;
import java.util.function.Predicate;
import java.util.stream.Stream;

public interface Collection<E> extends java.lang.Iterable<E>
{
    boolean add(E p0); // manual summary
    boolean contains(Object p0); // manual neutral
    boolean isEmpty(); // manual neutral
    default boolean removeIf(java.util.function.Predicate<? super E> p0){ return false; } // manual neutral
    default java.util.stream.Stream<E> stream(){ return null; } // manual summary
    int size(); // manual neutral
    java.util.Iterator<E> iterator(); // manual summary

    boolean	addAll(Collection<? extends E> c);
    Object[] toArray();
    <T> T[] toArray(T[] a);
}
