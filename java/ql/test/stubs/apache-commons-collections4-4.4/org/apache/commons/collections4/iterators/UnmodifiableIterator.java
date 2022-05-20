// Generated automatically from org.apache.commons.collections4.iterators.UnmodifiableIterator for testing purposes

package org.apache.commons.collections4.iterators;

import java.util.Iterator;
import org.apache.commons.collections4.Unmodifiable;

public class UnmodifiableIterator<E> implements Iterator<E>, Unmodifiable
{
    protected UnmodifiableIterator() {}
    public E next(){ return null; }
    public boolean hasNext(){ return false; }
    public static <E> Iterator<E> unmodifiableIterator(Iterator<? extends E> p0){ return null; }
    public void remove(){}
}
