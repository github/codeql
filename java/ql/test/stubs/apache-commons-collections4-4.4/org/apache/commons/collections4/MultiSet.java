// Generated automatically from org.apache.commons.collections4.MultiSet for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;

public interface MultiSet<E> extends Collection<E>
{
    Iterator<E> iterator();
    Set<E> uniqueSet();
    Set<MultiSet.Entry<E>> entrySet();
    boolean add(E p0);
    boolean containsAll(Collection<? extends Object> p0);
    boolean equals(Object p0);
    boolean remove(Object p0);
    boolean removeAll(Collection<? extends Object> p0);
    boolean retainAll(Collection<? extends Object> p0);
    int add(E p0, int p1);
    int getCount(Object p0);
    int hashCode();
    int remove(Object p0, int p1);
    int setCount(E p0, int p1);
    int size();
    static public interface Entry<E>
    {
        E getElement();
        boolean equals(Object p0);
        int getCount();
        int hashCode();
    }
}
