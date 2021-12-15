// Generated automatically from org.apache.commons.collections4.Bag for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;

public interface Bag<E> extends Collection<E>
{
    Iterator<E> iterator();
    Set<E> uniqueSet();
    boolean add(E p0);
    boolean add(E p0, int p1);
    boolean containsAll(Collection<? extends Object> p0);
    boolean remove(Object p0);
    boolean remove(Object p0, int p1);
    boolean removeAll(Collection<? extends Object> p0);
    boolean retainAll(Collection<? extends Object> p0);
    int getCount(Object p0);
    int size();
}
