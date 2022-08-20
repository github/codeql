// Generated automatically from com.google.common.collect.Multiset for testing purposes

package com.google.common.collect;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.Spliterator;
import java.util.function.Consumer;
import java.util.function.ObjIntConsumer;

public interface Multiset<E> extends Collection<E>
{
    Iterator<E> iterator();
    Set<E> elementSet();
    Set<Multiset.Entry<E>> entrySet();
    String toString();
    boolean add(E p0);
    boolean contains(Object p0);
    boolean containsAll(Collection<? extends Object> p0);
    boolean equals(Object p0);
    boolean remove(Object p0);
    boolean removeAll(Collection<? extends Object> p0);
    boolean retainAll(Collection<? extends Object> p0);
    boolean setCount(E p0, int p1, int p2);
    default Spliterator<E> spliterator(){ return null; }
    default void forEach(Consumer<? super E> p0){}
    default void forEachEntry(ObjIntConsumer<? super E> p0){}
    int add(E p0, int p1);
    int count(Object p0);
    int hashCode();
    int remove(Object p0, int p1);
    int setCount(E p0, int p1);
    int size();
    static public interface Entry<E>
    {
        E getElement();
        String toString();
        boolean equals(Object p0);
        int getCount();
        int hashCode();
    }
}
