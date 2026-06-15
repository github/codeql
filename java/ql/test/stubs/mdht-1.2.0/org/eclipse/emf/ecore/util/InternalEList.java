// Generated automatically from org.eclipse.emf.ecore.util.InternalEList for testing purposes

package org.eclipse.emf.ecore.util;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.common.util.EList;

public interface InternalEList<E> extends org.eclipse.emf.common.util.EList<E>
{
    <T> T[] basicToArray(T[] p0);
    E basicGet(int p0);
    E setUnique(int p0, E p1);
    NotificationChain basicAdd(E p0, NotificationChain p1);
    NotificationChain basicRemove(Object p0, NotificationChain p1);
    Object[] basicToArray();
    boolean addAllUnique(int p0, java.util.Collection<? extends E> p1);
    boolean addAllUnique(java.util.Collection<? extends E> p0);
    boolean basicContains(Object p0);
    boolean basicContainsAll(Collection<? extends Object> p0);
    int basicIndexOf(Object p0);
    int basicLastIndexOf(Object p0);
    java.util.Iterator<E> basicIterator();
    java.util.List<E> basicList();
    java.util.ListIterator<E> basicListIterator();
    java.util.ListIterator<E> basicListIterator(int p0);
    void addUnique(E p0);
    void addUnique(int p0, E p1);
}
