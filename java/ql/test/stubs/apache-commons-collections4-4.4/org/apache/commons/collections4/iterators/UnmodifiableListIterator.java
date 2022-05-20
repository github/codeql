// Generated automatically from org.apache.commons.collections4.iterators.UnmodifiableListIterator for testing purposes

package org.apache.commons.collections4.iterators;

import java.util.ListIterator;
import org.apache.commons.collections4.Unmodifiable;

public class UnmodifiableListIterator<E> implements ListIterator<E>, Unmodifiable
{
    protected UnmodifiableListIterator() {}
    public E next(){ return null; }
    public E previous(){ return null; }
    public boolean hasNext(){ return false; }
    public boolean hasPrevious(){ return false; }
    public int nextIndex(){ return 0; }
    public int previousIndex(){ return 0; }
    public static <E> ListIterator<E> umodifiableListIterator(ListIterator<? extends E> p0){ return null; }
    public void add(E p0){}
    public void remove(){}
    public void set(E p0){}
}
