// Generated automatically from org.apache.commons.collections4.set.AbstractSortedSetDecorator for testing purposes

package org.apache.commons.collections4.set;

import java.util.Comparator;
import java.util.Set;
import java.util.SortedSet;
import org.apache.commons.collections4.set.AbstractSetDecorator;

abstract public class AbstractSortedSetDecorator<E> extends AbstractSetDecorator<E> implements SortedSet<E>
{
    protected AbstractSortedSetDecorator(){}
    protected AbstractSortedSetDecorator(Set<E> p0){}
    protected SortedSet<E> decorated(){ return null; }
    public Comparator<? super E> comparator(){ return null; }
    public E first(){ return null; }
    public E last(){ return null; }
    public SortedSet<E> headSet(E p0){ return null; }
    public SortedSet<E> subSet(E p0, E p1){ return null; }
    public SortedSet<E> tailSet(E p0){ return null; }
}
